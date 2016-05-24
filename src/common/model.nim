import opengl
import nimasset/obj
import streams
import strutils

type mesh* = object
  data*: seq[GLfloat]
  textureData*: seq[GLfloat]
  normalsData*: seq[GLfloat]
  indicesData: seq[cint]

  buffer*: GLuint
  textureBuffer*: GLuint
  normalsBuffer*: GLuint
  indicesBuffer*: GLuint
  vaoBuffer*: GLuint

proc init*(m: var mesh) =
  echo "mesh initiated"
  # create and bind the vertex array
  glGenVertexArrays(1, addr m.vaoBuffer)
  glBindVertexArray(m.vaoBuffer)


  # vertex
  glGenBuffers(1, addr m.buffer)
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(m.data.len*sizeof(GLfloat)),
    addr m.data[0],
    GL_STATIC_DRAW
  )

  # sort out some attributes
  var a: pointer
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
  glGenBuffers(1, addr m.textureBuffer)
  glBindBuffer(GL_ARRAY_BUFFER, m.textureBuffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(36),
    addr m.textureData[0],
    GL_STATIC_DRAW
  )

  if m.indicesData != nil:
    glGenBuffers(1, addr m.indicesBuffer)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m.indicesBuffer)
    glBufferData(
      GL_ELEMENT_ARRAY_BUFFER,
      GLsizeiptr(36),
      addr m.indicesData[0],
      GL_STATIC_DRAW
    )

  glVertexAttribPointer(
    1,
    2,
    cGL_FLOAT,
    false,
    0,
    a
  )

  glBindVertexArray(0)

proc upload*(m: var mesh) =
  ## Send data to the GPU
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(m.data.len),
    addr m.data[0],
    GL_DYNAMIC_DRAW
  )


proc draw*(m: var mesh) =
  glEnableVertexAttribArray(0)
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)

  glEnableVertexAttribArray(1)
  glBindBuffer(GL_ARRAY_BUFFER, m.textureBuffer)

  glEnableVertexAttribArray(2)
  glBindVertexArray(m.vaoBuffer)

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

proc loadObj*(m: var mesh, filepath: string) =
  let
    loader: ObjLoader = new(ObjLoader)
    f = open("res/obj/cube.obj")
    fs = newFileStream(f)

  # m.init()
  proc addVertex(m: var mesh, x, y, z: float) =
    m.data = m.data & @[(GLfloat)x, (GLfloat)y, (GLfloat)z]

  proc addTextureVertex(m: var mesh, x, y, z: float) =
    m.textureData = m.textureData & @[(GLfloat)x, (GLfloat)y, (GLfloat)z]

  proc drop(m: var mesh, x, y, z: float) =
    return

  proc addIndice(m: var mesh, vi_0, vi_1, vi_2, ti_0, ti_1, ti_2, ni0, ni1, ni2: int)=
    m.indicesData = m.indicesData & @[(cint)vi_0, (cint)vi_1, (cint)vi_2]
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
