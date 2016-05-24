import opengl
import nimasset/obj
import streams
import strutils

type model* = object
  data*: seq[GLfloat]
  textureData*: seq[GLfloat]
  normalsData*: seq[GLfloat]
  indicesData: seq[uint]

  buffer*: GLuint
  textureBuffer*: GLuint
  normalsBuffer*: GLuint
  indicesBuffer*: GLuint
  vaoBuffer*: GLuint

proc init*(m: var model) =
  echo "Model initiated"
  # create and bind the vertex array
  glGenVertexArrays(1, addr m.vaoBuffer)
  glBindVertexArray(m.vaoBuffer)

  # sort out some attributes
  var a: pointer
  # vertex
  glVertexAttribPointer(
    0,
    3,
    cGL_FLOAT,
    false,
    # sizeof(GLfloat) * 3,
    0,
    a
  )
  # UV
  glVertexAttribPointer(
    1,
    2,
    cGL_FLOAT,
    false,
    0,
    a
  )


  # deal with the vertex buffer
  glGenBuffers(1, addr m.buffer)
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(24),
    addr m.data[0],
    GL_STATIC_DRAW
  )
  # :tick:

  # deal with the UV buffer
  glGenBuffers(1, addr m.textureBuffer)
  glBindBuffer(GL_ARRAY_BUFFER, m.textureBuffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(36),
    addr m.textureData[0],
    GL_STATIC_DRAW
  )
  # :tick:


  # glGenBuffers(1, addr m.normalsBuffer)
  #
  # # glBindBuffer(GL_ARRAY_BUFFER, m.normalsBuffer)
  # glVertexAttribPointer(
  #   2,
  #   3,
  #   cGL_FLOAT,
  #   false,
  #   sizeof(cGL_FLOAT) * 3,
  #   nil
  # )

  glGenBuffers(1, addr m.indicesBuffer)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m.indicesBuffer)
  glBufferData(
    GL_ELEMENT_ARRAY_BUFFER,
    GLsizeiptr(36),
    addr m.indicesData[0],
    GL_STATIC_DRAW
  )

  # glVertexAttribPointer(
  #   3,
  #   3,
  #   GL_UNSIGNED_INT,
  #   false,
  #   sizeof(GLuint) * 3,
  #   nil
  # )

  glBindVertexArray(0)

proc upload*(m: var model) =
  ## Send data to the GPU
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(m.data.len),
    addr m.data[0],
    GL_DYNAMIC_DRAW
  )

  # if m.textureData.len != 0:
  #   glBindBuffer(GL_ARRAY_BUFFER, m.textureBuffer)
  #   glBufferData(
  #     GL_ARRAY_BUFFER,
  #     GLsizeiptr(sizeof(GLfloat) * m.textureData.len),
  #     addr m.textureData[0],
  #     GL_STATIC_DRAW
  #   )
  #
  # if m.normalsData.len != 0:
  #   glBindBuffer(GL_ARRAY_BUFFER, m.normalsBuffer)
  #   glBufferData(
  #     GL_ARRAY_BUFFER,
  #     GLsizeiptr(sizeof(GLfloat) * m.normalsData.len),
  #     addr m.normalsData[0],
  #     GL_STATIC_DRAW
  #   )
  #
  # if m.indicesData.len != 0:
  #   glBindBuffer(GL_ARRAY_BUFFER, m.indicesBuffer)
  #   glBufferData(
  #     GL_ARRAY_BUFFER,
  #     GLsizeiptr(sizeof(GLuint) * m.indicesData.len),
  #     addr m.indicesData[0],
  #     GL_STATIC_DRAW
  #   )


proc draw*(m: var model) =
  glEnableVertexAttribArray(0)
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)

  glEnableVertexAttribArray(1)
  glBindBuffer(GL_ARRAY_BUFFER, m.textureBuffer)

  glEnableVertexAttribArray(2)
  glBindVertexArray(m.vaoBuffer)


  # glEnableVertexAttribArray(2)
  # glBindBuffer(GL_ARRAY_BUFFER, m.normalsBuffer)

  # glEnableVertexAttribArray(4)
  # glBindBuffer(GL_ARRAY_BUFFER, m.indicesBuffer)

  var p: pointer

  if m.indicesData.len != 0:
    glDrawElements(
      GL_TRIANGLES,
      GLsizei(m.indicesData.len),
      GL_UNSIGNED_INT,
      p
    )

  glDisableVertexAttribArray(0)
  glDisableVertexAttribArray(1)
  glDisableVertexAttribArray(2)

# converter toGLfloat(a: float): GLfloat =
#   return GLfloat(a)

proc `$` (arr: array[0..0,  uint]): string =
  result = "["
  var length = arr.len
  for x in 0..length:
    if x == (length - 1):
      result &= cast[int](arr[x]).intToStr
    else:
      result &= cast[int](arr[x]).intToStr & ", "
  result &= "]"

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
    m.indicesData = m.indicesData & @[(uint)vi_0, (uint)vi_1, (uint)vi_2]
    m.textureData = m.textureData & @[(GLfloat)ti_0, (GLfloat)ti_1, (GLfloat)ti_2]


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

  echo m.data, m.data.len
  echo m.textureData, m.textureData.len
  echo m.indicesData, m.indicesData.len
  # echo sizeof(GLfloat)*3
