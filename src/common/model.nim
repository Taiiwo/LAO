import mesh
import glm
import opengl

type
  Model* = ref object
    meshes*: seq[Mesh]
    matrix*: Mat4x4[GLfloat]

# proc new*(m: var Model):
#   meshes = @[]
#   matrix = @[]

proc setPosition*(m: var Model, position: Vec3[GLfloat]) =
  m.matrix = mat4x4(GLfloat(1.0)).translate(position)

proc createNewMesh*(m: var Model, name: string): int =
  if m.meshes.len == 0:
    m.meshes = @[]
  var mesh = Mesh()

  # reset/init all mesh sequences
  mesh.data = @[vec3(GLfloat(0.0))] # a hacky fix
  mesh.indicesData = @[]
  mesh.normalData = @[] # and another one
  mesh.textureData = @[]

  m.meshes.add(mesh)
  return m.meshes.len - 1

proc init*(m: var Model) =
  for mesh in 0..<m.meshes.len:
    m.meshes[mesh].init()

proc upload*(m: var Model) =
  for mesh in 0..<m.meshes.len:
    m.meshes[mesh].upload()

proc draw*(m: var Model) =
  for mesh in 0..<m.meshes.len:
    m.meshes[mesh].draw()

when defined(DRAW_NORMALS):
  proc drawNormals*(m: var Model) =
    for mesh in 0..<m.meshes.len:
      m.meshes[mesh].drawNormals()
