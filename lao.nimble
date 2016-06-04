# Package

version       = "0.0.0"
author        = "Emati Mitame, Taiiwo Llort"
description   = "Laser Art Online"
license       = "GPLv3"

# Dependencies

requires "nim >= 0.13.0"
requires "opengl >= 1.0.1"
requires "glm >= 0.1.1"
requires "https://github.com/ephja/nim-glfw >= 0.2.1"

bin = @[
  "src/main"
]

before run:
  echo "Building LAO.."
  exec "nimble build"

task run, "Run LAO":
  echo "Running LAO!"
  exec "src/main"
