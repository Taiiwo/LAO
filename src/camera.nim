import glm
import math

export glm

type
  RotatingCamera = ref object
    y*: float
    angle*: float
    radius*: float
    Projection*: Mat4x4[float]

method setY(self: var RotatingCamera, y: float) {.base.} =
  self.y = y

method setAngle(this: RotatingCamera, angle: float) {.base.} =
  this.angle = angle

method setRadius(this: RotatingCamera, r: float) {.base.} =
  this.radius = r

method getAngle(this: RotatingCamera): float {.base.} =
  return this.angle

method getRadius(this: RotatingCamera): float {.base.} =
  return this.radius

method getX(this: RotatingCamera): float {.base.} =
  return sin(PI * this.getAngle()/180)*this.getRadius()

method getY(this: RotatingCamera): float {.base.} =
  return this.y

method getZ(this: RotatingCamera): float {.base.} =
  return cos(PI * this.getAngle()/180)*this.getRadius()

proc getViewMatrix*(this: RotatingCamera): Mat4x4[float] =
  return lookAt(
    vec3(this.getX(), this.getY(), this.getZ()),
    vec3(0.0, 0.0, 0.0),
    vec3(0.0, 1.0, 1.0)
  )

proc getProjectionMatrix*(this: RotatingCamera): Mat4x4[float] =
  return perspective(90.0, 4/3, 0.1, 100.0)

proc getViewProjectionMatrix*(this: RotatingCamera): Mat4x4[float] =
  return this.getProjectionMatrix() * this.getViewMatrix()

proc rotatingCamera*(y: float, angle: float, radius: float): RotatingCamera =
  return RotatingCamera(y: y, angle: angle, radius: radius)
