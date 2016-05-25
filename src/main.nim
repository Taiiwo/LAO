
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
glDepthFunc(GL_LEQUAL)

glEnable(GL_BLEND)
glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

glClearColor(0.0f, 0.0f, 0.4f, 1)

window.stickyKeys = false

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


var
  errorCode: int
  lightPos: Vec3[float] = vec3(5.0, 5.0, 5.0)
  Valid_lightPos: Vec3[GLfloat]


var m: mesh

loadObj(m, "res/obj/suzanne.obj")
m.init()
# m.upload()

var
  M, V, MVP: Mat4x4[GLfloat]
  P: Mat4x4[float64]

M = mat4x4((GLfloat)1.0)#.scale(vec3(GLfloat(0.3), 0.3, 0.3))
V = lookAt(
  vec3((GLfloat)5.0, 5.0, 5.0),
  vec3((GLfloat)0.0, 0.0, 0.0),
  vec3((GLfloat)0.0, 1.0, 0.0)
)
P = perspective(
  GLfloat(90.0),
  GLfloat(4.0/3.0),
  GLfloat(-10.0),
  GLfloat(0.0)
)

var glP: Mat4x4[GLfloat] = P
MVP = glP * V * M


while not window.shouldClose:
  errorCode = 0

  MVP = glP * V * M

  # echo "MVP: ", MVP

  m.upload()

  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

  glUseProgram(shaderId)
  glUniformMatrix4fv(
    mvpId,
    (GLsizei)1,
    false,
    MVP.caddr
  )

  m.draw()

  window.update()
  window.swapBufs()

  # M = M.rotate(
  #   vec3(cast[GLfloat](0.0), -1.0, 0.0),
  #   0.1f
  # )

  if window.isKeyDown(keyLeft):
    M = M.rotate(
      vec3(GLfloat(0.0), -1.0, 0.0),
      0.1f
    )
  if window.isKeyDown(keyRight):
    M = M.rotate(
      vec3(GLfloat(0.0), 1.0, 0.0),
      0.1f
    )
  if window.isKeyDown(keyUp):
    M = M.rotate(
      vec3(GLfloat(-1.0), 0.0, 0.0),
      0.1f
    )
  if window.isKeyDown(keyDown):
    M = M.rotate(
      vec3(GLfloat(1.0), 0.0, 0.0),
      0.1f
    )
  if window.isKeyDown(keyEqual):
    M = M.scale(
      vec3(GLfloat(1.1))
    )
  if window.isKeyDown(keyMinus):
    M = M.scale(
      vec3(GLfloat(1/1.1))
    )

  if window.isKeyDown(keyEscape):
    window.shouldClose = true
