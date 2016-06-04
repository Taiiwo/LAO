import glfw
import glfw/wrapper
import glm
import glm/mat
import opengl


import common/shader
import common/mesh
import common/model
import loader/obj
import camera

#import nimasset/obj
import streams
import strutils
import times
# import tables

import os

glfw.init()

# var GLFWvidmode = glfw.getPrimaryMonitor().vidMode()
let window = newGlWin(resizable=false, version=glv33)
# window.setVerticalSync(false)


glfw.makeContextCurrent(window)

# discard gladLoadGL(getProcAddress)
loadExtensions()

glEnable(GL_DEPTH_TEST)
glDepthFunc(GL_LEQUAL)

glCullFace(GL_BACK)
glEnable(GL_CULL_FACE)

# glEnable(GL_NORMALIZE)

glEnable(GL_BLEND)
glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

glClearColor(0.0f, 0.0f, 0.4f, 1)

window.stickyKeys = false

let
  shaderId: GLuint = loadShaderSet("res/shaders/simple.vs", "res/shaders/simple.fs")
  mvpId = glGetUniformLocation(shaderId,  "MVP")
  mId = glGetUniformLocation(shaderId, "M")
  vId = glGetUniformLocation(shaderId, "V")
  lightposId = glGetUniformLocation(shaderId, "LightPosition_worldspace")
  # textureShaderId = glGetUniformLocation(shaderId, "textureA")

  rot_cam = rotatingCamera(y=3, angle=1.0, radius=3)

converter toUnsignedInt(a: int): uint =
  return (uint)a

#clear the screen
# clClearColor(0.0)
glClearDepth((GLfloat)1.0)

converter toGLfloat(a: float): GLfloat =
  return (GLfloat)a


var
  errorCode: int
  lightPos: Vec3[GLfloat] = vec3(GLfloat(9.0), GLfloat(9.0), GLfloat(9.0))


var
  m: Model

# m = loadObjFromFile("res/obj/cube.obj")
m = loadObjFromFile("res/obj/earth.obj")
# m = loadObjFromFile("res/obj/plane.obj")
# m = loadObjFromFile("res/obj/suzanne.obj")
# m = loadObjFromFile("res/obj/test.obj")
m.init()
# m.upload()

var
  M, V, P, MVP: Mat4x4[GLfloat]
  # P: Mat4x4[float64]

M = mat4x4(GLfloat(1.0))#.scale(vec3(GLfloat(0.3), 0.3, 0.3))
# V = lookAt(
#   vec3((GLfloat)5.0, 5.0, 5.0),
#   vec3((GLfloat)0.0, 0.0, 0.0),
#   vec3((GLfloat)0.0, 1.0, 0.0)
# )
P = perspective(
  GLfloat(90.0),
  GLfloat(4.0/3.0),
  GLfloat(-10.0),
  GLfloat(0.0)
)

# var glP: Mat4x4[GLfloat] = P
# MVP = glP * V * M

var
  frame: uint = 0
  last_frame: uint = 0
  last_fps = times.getTime()

glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
m.upload()
while not window.shouldClose:
  errorCode = 0
  # M = m.matrix
  V = rot_cam.getViewMatrix()
  P = rot_cam.getProjectionMatrix()
  MVP = P * V * M

  # echo "MVP: ", MVP

  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

  glUseProgram(shaderId)
  glUniformMatrix4fv(mvpId, (GLsizei)1, false, MVP.caddr)
  glUniformMatrix4fv(mId, (GLsizei)1, false, M.caddr)
  glUniformMatrix4fv(vId, (GLsizei)1, false, V.caddr)

  glUniform3fv(lightposId, (GLsizei)1, lightpos.caddr)

  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
  m.draw()

  glUseProgram(0)
  when defined(DRAW_NORMALS):
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
    m.drawNormals()

  window.update()
  # window.swapBufs()

  let dt: int64 = (times.getTime() - last_fps)
  # echo "dt: ", dt
  if dt >= 1:
    let fps = float(frame - last_frame)/float(dt)
    echo "Current stats: FPS: ", fps, " Frame: ", frame

    last_fps = times.getTime()
    last_frame = frame

  frame += 1
  # M = M.rotate(
  #   vec3(cast[GLfloat](0.0), -1.0, 0.0),
  #   0.1f
  # )

  if window.isKeyDown(keyLeft):
    rot_cam.setAngle(rot_cam.getAngle() + 10)
  if window.isKeyDown(keyRight):
    rot_cam.setAngle(rot_cam.getAngle() - 10)
  if window.isKeyDown(keyUp):
    rot_cam.setY(rot_cam.getY() + 0.2)
  if window.isKeyDown(keyDown):
    rot_cam.setY(rot_cam.getY() - 0.2)
  if window.isKeyDown(keyEqual):
    rot_cam.setRadius(rot_cam.getRadius - 0.2)
  if window.isKeyDown(keyMinus):
    rot_cam.setRadius(rot_cam.getRadius + 0.2)

  if window.isKeyDown(keyEscape):
    window.shouldClose = true
