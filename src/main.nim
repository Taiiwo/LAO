
import glfw
import glfw/wrapper

import glm
import glm/mat
import opengl
# import ../external/glad/gl
import common/shader
import common/model
import camera

import nimasset/obj
import streams
import strutils

import tables

import os

glfw.init()

# var GLFWvidmode = glfw.getPrimaryMonitor().vidMode()
let window = newGlWin(resizable=false, version=glv33)

glfw.makeContextCurrent(window)

# discard gladLoadGL(getProcAddress)
loadExtensions()

glEnable(GL_DEPTH_TEST)
glEnable(GL_LINE_SMOOTH)

window.stickyKeys = false

glClearColor(0.0f, 0.0f, 0.4f, 1)

let
  shaderId: GLuint = loadShaderSet("res/shaders/base.vs", "res/shaders/base.fs")
  mvpId = glGetUniformLocation(shaderId,  "MVP")
  # mId = glGetUniformLocation(shaderId, "M")
  # vId = glGetUniformLocation(shaderId, "V")
  # lightposId = glGetUniformLocation(shaderId, "LightPosition_worldspace")
  # textureShaderId = glGetUniformLocation(shaderId, "textureA")

  rot_cam = rotatingCamera(y=3, angle=0, radius=3)

converter toUnsignedInt(a: int): uint =
  return (uint)a

#clear the screen
# clClearColor(0.0)
glClearDepth((GLfloat)1.0)

converter toGLfloat(a: float): GLfloat =
  return (GLfloat)a

# do some shit setup
var
  Model: Mat4x4[GLfloat] = mat4x4(2.0)
  View: Mat4x4[GLfloat] = rot_cam.getViewMatrix()
  Projection: Mat4x4[GLfloat] = rot_cam.getProjectionMatrix()
  MVP: Mat4x4[GLfloat]
  Valid_Model: Mat4x4[GLfloat]
  Valid_View: Mat4x4[GLfloat]
  Valid_Projection: Mat4x4[GLfloat]
  Valid_MVP: Mat4x4[GLfloat]

var
  errorCode: int
  lightPos: Vec3[float] = vec3(5.0, 5.0, 5.0)
  Valid_lightPos: Vec3[GLfloat]


var m: model

loadObj(m, "res/obj/cube.obj")
m.init()
m.upload()

while not window.shouldClose:
  echo "rendering"
  errorCode = 0
  MVP = Projection * View * Model

  # Valid_Model = Model
  # Valid_View = View
  Valid_MVP = MVP
  Valid_lightPos = lightPos

  # m.upload()

  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

  glUseProgram(shaderId)
  glUniformMatrix4fv(
    mvpId,
    (GLsizei)1,
    false,
    Valid_MVP.caddr
  )

  m.draw()


  window.update()
  # window.swapBufs()

  if window.isKeyDown(keyLeft):
    Model = Model.rotate(
      vec3(cast[GLfloat](0.0), -1.0, 0.0),
      0.1f
    )
  if window.isKeyDown(keyRight):
    Model = Model.rotate(
      vec3(cast[GLfloat](0.0), 1.0, 0.0),
      0.1f
    )
  if window.isKeyDown(keyUp):
    Model = Model.rotate(
      vec3(cast[GLfloat](-1.0), 0.0, 0.0),
      0.1f
    )
  if window.isKeyDown(keyDown):
    Model = Model.rotate(
      vec3(cast[GLfloat](1.0), 0.0, 0.0),
      0.1f
    )
  sleep(1000)
