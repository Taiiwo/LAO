import opengl
import nimasset/obj
import streams
import strutils

type model* = object
  buffer*: GLuint
  data*: seq[GLfloat]
  textureBuffer*: GLuint
  indicesBuffer*: GLuint
  vaoBuffer*: GLuint
  textureData*: seq[GLfloat]
  indicesData: seq[cint]

proc init*(m: var model) =
  echo "Model initiated"
  # create and bind the vertex array
  glGenVertexArrays(1, addr m.vaoBuffer)
  glBindVertexArray(m.vaoBuffer)

  # create and bind the buffer
  glGenBuffers(1, addr m.buffer)
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(sizeof(GLfloat) * m.data.len),
    addr m.data[0],
    GL_STATIC_DRAW
  )

  var a: pointer
  glVertexAttribPointer(
    0,
    3,
    cGL_FLOAT,
    false,
    sizeof(GLfloat) * 3,
    a
  )

  glGenBuffers(1, addr m.indicesBuffer)
  glVertexAttribPointer(
    1,
    3,
    cGL_FLOAT,
    false,
    0,
    nil
  )

  glGenBuffers(1, addr m.textureBuffer)
  glVertexAttribPointer(
    2,
    2,
    cGL_FLOAT,
    false,
    sizeof(GLfloat) * 3,
    a
  )

  glBindVertexArray(0)

proc upload*(m: var model) =
  ## Send data to the GPU
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(sizeof(GLfloat)*m.data.len),
    addr m.data[0],
    GL_DYNAMIC_DRAW
  )

  if m.textureData.len != 0:
    glBindBuffer(GL_ARRAY_BUFFER, m.textureBuffer)
    glBufferData(
      GL_ARRAY_BUFFER,
      GLsizeiptr(sizeof(GLfloat) * m.textureData.len),
      addr m.textureData[0],
      GL_STATIC_DRAW
    )

  if m.indicesData.len != 0:
    glBindBuffer(GL_ARRAY_BUFFER, m.indicesBuffer)
    glBufferData(
      GL_ARRAY_BUFFER,
      GLsizeiptr(sizeof(GLuint) * m.indicesData.len),
      addr m.indicesData[0],
      GL_STATIC_DRAW
    )


proc draw*(m: var model) =
  glEnableVertexAttribArray(0)
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)

  glEnableVertexAttribArray(1)
  glBindBuffer(GL_ARRAY_BUFFER, m.textureBuffer)

  glEnableVertexAttribArray(2)
  glBindBuffer(GL_ARRAY_BUFFER, m.vaoBuffer)

  var p: pointer

  if m.indicesData != nil:
    glDrawElements(
      GL_TRIANGLES,
      GLsizei(m.indicesData.len),
      GL_UNSIGNED_INT,
      p
    )

  glDisableVertexAttribArray(2)
  glDisableVertexAttribArray(1)
  glDisableVertexAttribArray(0)

converter toGLfloat(a: float): GLfloat =
  return GLfloat(a)


proc loadObj*(m: var model, filepath: string) =
  let
    loader: ObjLoader = new(ObjLoader)
    f = open("res/obj/cube.obj")
    fs = newFileStream(f)

  # m.init()
  proc addVertex(m: var model, x, y, z: float) =
    m.data = m.data & @[(GLfloat)x, (GLfloat)y, (GLfloat)z]

  proc addTextureVertex(m: var model, x, y, z: float) =
    m.textureData = m.textureData & @[(GLfloat)x, (GLfloat)y, (GLfloat)z]

  proc drop(m: var model, x, y, z: float) =
    return

  proc addIndice(m: var model, vi_0, vi_1, vi_2, ti_0, ti_1, ti_2, ni0, ni1, ni2: int)=
    m.indicesData = m.indicesData & @[
      (cint)vi_0, (cint)vi_1, (cint)vi_2,
      (cint)ti_0, (cint)ti_1, (cint)ti_2,
      (cint)ni0, (cint)ni1, (cint)ni2
    ]

  try:
    loadMeshData(loader, fs,
      m.addVertex,
      m.addTextureVertex,
      m.drop,
      m.addIndice
    )
  except ValueError:
    let
      # e = getCurrentException()
      msg = getCurrentExceptionMsg()
    quit msg
