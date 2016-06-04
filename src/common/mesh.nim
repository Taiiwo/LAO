import opengl
import glm
import nimasset/obj
import streams
import strutils
# import logging

# addHandler(newConsoleLogger())

type Mesh* = object
  data*: seq[Vec3[GLfloat]]
  textureData*: seq[Vec2[GLfloat]]
  normalData*: seq[Vec3[GLfloat]]

  indicesData*: seq[Vec3[cint]]
  textureIndicesData*: seq[Vec3[cint]]
  normalIndicesData*: seq[Vec3[cint]]


  buffer*: GLuint
  textureBuffer*: GLuint
  normalsBuffer*: GLuint
  indicesBuffer*: GLuint

  vaoBuffer*: GLuint


proc deindex[T](data: var seq[T], indices: var seq[Vec3[cint]]): seq[T] =
  var indexed: seq[T] = @[]
  if data.len != 0:
    for x in indices:
      indexed.add(data[x.x - 1])
      indexed.add(data[x.y - 1])
      indexed.add(data[x.z - 1])
  return indexed


proc init*(m: var Mesh) =
  # deindex stuff
  var
    textureSeq = deindex(m.textureData, m.textureIndicesData)
    normalSeq = deindex(m.normalData, m.normalIndicesData)


  # create and bind the vertex array
  glGenVertexArrays(1, addr m.vaoBuffer)
  glBindVertexArray(m.vaoBuffer)


  # vertex
  glGenBuffers(1, addr m.buffer)
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(m.data.len * sizeof(Vec3[GLfloat])),
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
    sizeof(GLfloat) * 3,
    a
  )

  # UV
  glGenBuffers(1, addr m.textureBuffer)
  glBindBuffer(GL_ARRAY_BUFFER, m.textureBuffer)
  if m.textureData.len != 0:
    glBufferData(
      GL_ARRAY_BUFFER,
      GLsizeiptr(textureSeq.len * sizeof(Vec3[GLfloat])),
      addr textureSeq[0],
      GL_STATIC_DRAW
    )
  glVertexAttribPointer(
    1,
    2,
    cGL_FLOAT,
    false,
    0,
    nil
  )


  # normals
  if normalSeq.len != 0:
    glGenBuffers(1, addr m.normalsBuffer)
    glBindBuffer(GL_ARRAY_BUFFER, m.normalsBuffer)
    glBufferData(
      GL_ARRAY_BUFFER,
      GLsizeiptr(normalSeq.len * sizeof(Vec3[GLfloat])),
      addr normalSeq[0],
      GL_STATIC_DRAW
    )
  glVertexAttribPointer(
    2,
    3,
    cGL_FLOAT,
    false,
    0,
    nil
  )

  if m.indicesData.len != 0:
    glGenBuffers(1, addr m.indicesBuffer)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m.indicesBuffer)
    glBufferData(
      GL_ELEMENT_ARRAY_BUFFER,
      GLsizeiptr(m.indicesData.len * sizeof(Vec3[GLuint])),
      addr m.indicesData[0],
      GL_STATIC_DRAW
    )

proc upload*(m: var Mesh) =
  ## Send data to the GPU
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)
  glBufferData(
    GL_ARRAY_BUFFER,
    GLsizeiptr(m.data.len * sizeof(Vec3[GLfloat])),
    addr m.data[0],
    GL_DYNAMIC_DRAW
  )


proc draw*(m: var Mesh) =
  glEnableVertexAttribArray(0)
  glBindBuffer(GL_ARRAY_BUFFER, m.buffer)

  glEnableVertexAttribArray(1)
  glBindBuffer(GL_ARRAY_BUFFER, m.textureBuffer)

  glEnableVertexAttribArray(2)
  glBindBuffer(GL_ARRAY_BUFFER, m.normalsBuffer)

  glBindVertexArray(m.vaoBuffer)

  var p: pointer

  if m.indicesData.len != 0:
    glDrawElements(
      GL_TRIANGLES,
      GLsizei(m.indicesData.len*3),
      GL_UNSIGNED_INT,
      p
    )

  glDisableVertexAttribArray(0)
  glDisableVertexAttribArray(1)
  glDisableVertexAttribArray(2)

proc addVertex*(m: var Mesh, x, y, z: float) =
  if m.data.len == 0:
    m.data = @[]
  m.data.add(vec3(GLfloat(x), GLfloat(y), GLfloat(z)))

proc addTextureVertex*(m: var Mesh, x, y: float) =
  if m.textureData.len == 0:
    m.textureData = @[]
  m.textureData.add(vec2((GLfloat)x, (GLfloat)y))

proc addNormalVertex*(m: var Mesh, x, y, z: float) =
  if m.normalData.len == 0:
    m.normalData = @[]
  m.normalData.add(vec3(GLfloat(x), GLfloat(y), GLfloat(z)))

proc addIndice*(m: var Mesh, vi_0, vi_1, vi_2: int)=
  if m.indicesData.len == 0:
    m.indicesData = @[]
  m.indicesData.add(vec3((cint)vi_0, (cint)vi_1, (cint)vi_2))

proc addTextureIndice*(m: var Mesh, ti_0, ti_1, ti_2: int) =
  if m.textureIndicesData.len == 0:
    m.textureIndicesData = @[]
  m.textureIndicesData.add(vec3((cint)ti_0, (cint)ti_1, (cint)ti_2))

proc addNormalIndice*(m: var Mesh, ni_0, ni_1, ni_2: int) =
  if m.normalIndicesData.len == 0:
    m.normalIndicesData = @[]
  m.normalIndicesData.add(vec3((cint)ni_0, (cint)ni_1, (cint)ni_2))

proc `$` (arr: array[0..0,  uint]): string =
  result = "["
  var length = arr.len
  for x in 0..length:
    if x == (length - 1):
      result &= cast[int](arr[x]).intToStr
    else:
      result &= cast[int](arr[x]).intToStr & ", "
  result &= "]"

proc setSmoothShading*(m: var Mesh, flag: bool) =
  # Do nothing!
  return

# proc loadObj*(m: var Mesh, filepath: string) =
#   let
#     loader: ObjLoader = new(ObjLoader)
#     f = open(filepath)
#     fs = newFileStream(f)
#
#   # reset/init all sequences
#   m.data = @[vec3(GLfloat(0.0))] # a hacky fix
#   m.indicesData = @[]
#   m.normalData = @[]
#   m.textureData = @[]
#
#   # m.init()
#
#   proc addAllIndices(m: var Mesh, vi_0, vi_1, vi_2, ti_0, ti_1, ti_2, ni_0, ni_1, ni_2: int) =
#     m.addIndice(vi_0, vi_1, vi_2)
#     m.addTextureIndice(ti_0, ti_1, ti_2)
#     m.addNormalIndice(ni_0, ni_1, ni_2)
#
#   try:
#     loadMeshData(loader, fs,
#       m.addVertex,
#       m.addTextureVertex,
#       m.addNormalVertex,
#       m.addAllIndices
#     )
#   except ValueError:
#     let
#       # e = getCurrentException()
#       msg = getCurrentExceptionMsg()
#     quit msg
