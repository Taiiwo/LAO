from math import pi, sin, cos
from direct.showbase.ShowBase import ShowBase
from direct.task import Task
from direct.actor.Actor import Actor
from direct.interval.IntervalGlobal import Sequence
from panda3d.core import Point3

class OrbitCamera():

    def __init__(self, parent, speed, sensitivity, target):
        self.sensitivity = sensitivity
        self.parent = parent
        self.target = target
        # rotate
        parent.accept("mouse3", self.move_camera)
        parent.accept("mouse3-up", self.stop_camera)

    def move_camera(self):
        self.click_pos_x = base.mouseWatcherNode.getMouseX()
        self.click_pos_y = base.mouseWatcherNode.getMouseY()
        self.click_pos_h = self.parent.camera.getH()
        self.click_pos_p = self.parent.camera.getP()
        self.parent.taskMgr.add(self.move_camera_task, "move_camera")

    def move_camera_task(self, task):
        diff_x = base.mouseWatcherNode.getMouseX() - self.click_pos_x
        diff_y = base.mouseWatcherNode.getMouseY() - self.click_pos_y

        self.sensitivity = 2
        self.zoom = 20.0

        self.parent.camera.setPos(
            self.target.getX() + self.zoom * sin(diff_x),
            self.target.getY() + self.zoom * cos(diff_x),
            self.target.getZ() - self.zoom * sin(diff_y)
        )
        self.parent.camera.lookAt(
            self.target.getX(),
            self.target.getY(),
            self.target.getZ()
        )

        return Task.cont

    def stop_camera(self):
        self.parent.taskMgr.remove("move_camera")
