from math import pi, sin, cos

from direct.showbase.ShowBase import ShowBase
from direct.task import Task
from direct.actor.Actor import Actor
from direct.interval.IntervalGlobal import Sequence
from panda3d.core import Point3

class LAO(ShowBase):

    def __init__(self):
        ShowBase.__init__(self)

        # Disable the camera trackball controls.
        self.disableMouse()

        # Load the environment model.
        self.scene = self.loader.loadModel("models/environment")
        # Reparent the model to render.
        self.scene.reparentTo(self.render)
        # Apply scale and position transforms on the model.
        self.scene.setScale(0.25, 0.25, 0.25)
        self.scene.setPos(-8, 42, 0)

        # Add the spinCameraTask procedure to the task manager.
        self.taskMgr.add(self.gravity, "spinCameraTask")

        self.taskMgr.add(self.gravity, "gravity")

        # Load and transform the panda actor.
        self.pandaActor = Actor("models/panda-model",
                                {"walk": "models/panda-walk4"})
        self.pandaActor.setScale(0.005, 0.005, 0.005)
        self.pandaActor.reparentTo(self.render)

        # move forward
        self.accept("w", self.start_walk)
        self.accept("w-up", self.stop_walk)
        # rotate left and right
        self.accept("d", self.rotate_right)
        self.accept("d-up", self.stop_rotate)
        self.accept("a", self.rotate_left)
        self.accept("a-up", self.stop_rotate)
        self.pandaActor.velocity = 0
        # jump
        self.accept("space", self.jump)

    last_tick = 0
    def gravity(self, task):
        if self.pandaActor.getZ() > 0:
            self.pandaActor.velocity += 9.81 * (task.time - self.last_tick)
            self.pandaActor.setPos(self.pandaActor, 0, 0, -self.pandaActor.velocity)
        else:
            self.pandaActor.velocity = 0
        self.last_tick = task.time
        return Task.cont

    def jump(self):
        self.taskMgr.add(self.jump_task, "jump")

    def jump_task(self, task):
        height = 10
        thrust = height * -(task.time - self.last_tick)
        if self.pandaActor.getZ() < height:
            self.pandaActor.setPos(self.pandaActor, 0, 0, thrust)
            return Task.cont
        else:
            print("done")
            return Task.done

    def walking(self, task):
        speed = 3   # 5 units per tick
        self.pandaActor.setPos(
            self.pandaActor, 0, -speed, 0
        )
        return Task.cont

    def start_walk(self):
        # Loop its animation.
        self.pandaActor.loop("walk")
        # move the panda
        self.taskMgr.add(self.walking, "walking")

    def stop_walk(self):
        self.pandaActor.stop()
        self.pandaActor.pose("walk", 0)
        self.taskMgr.remove("walking")

    def rotate_right(self):
        self.taskMgr.add(self.rotate_right_task, "rotate_right")

    def rotate_right_task(self, task):
        self.pandaActor.setHpr(self.pandaActor, -0.1, 0, 0)
        return Task.cont
    def rotate_left(self):
        self.taskMgr.add(self.rotate_left_task, "rotate_left")

    def rotate_left_task(self, task):
        self.pandaActor.setHpr(self.pandaActor, 0.1, 0, 0)
        return Task.cont

    def stop_rotate(self):
        self.taskMgr.remove("rotate_right")
        self.taskMgr.remove("rotate_left")

    # Define a procedure to move the camera.
    def spinCameraTask(self, task):
        angleDegrees = self.pandaActor.getH()
        angleRadians = angleDegrees * (pi / 180.0)
        self.camera.setPos(
            self.pandaActor.getX() - 20 * sin(angleRadians),
            self.pandaActor.getY() + 20.0 * cos(angleRadians),
            3
        )
        self.camera.setHpr(angleDegrees + 180, 0, 0)
        return Task.cont

app = LAO()
app.run()
