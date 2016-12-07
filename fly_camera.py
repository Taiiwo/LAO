from math import pi, sin, cos

from direct.showbase.ShowBase import ShowBase
from direct.task import Task
from direct.actor.Actor import Actor
from direct.interval.IntervalGlobal import Sequence
from panda3d.core import Point3

class FlyCamera():

    def __init__(self, parent, speed, sensitivity):
        self.sensitivity = sensitivity
        self.parent = parent
        # in and out
        parent.accept("w", self.move, [0, speed, 0, "in"])
        parent.accept("w-up", self.stop, ["in"])
        parent.accept("s", self.move, [0, -speed, 0, "out"])
        parent.accept("s-up", self.stop, ["out"])
        # left and right
        parent.accept("d", self.move, [speed, 0, 0, "right"])
        parent.accept("d-up", self.stop, ["right"])
        parent.accept("a", self.move, [-speed, 0, 0, "left"])
        parent.accept("a-up", self.stop, ["left"])
        # up and down
        parent.accept("space", self.move, [0, 0, speed, "up"])
        parent.accept("space-up", self.stop, ["up"])
        parent.accept("shift", self.move, [0, 0, -speed, "down"])
        parent.accept("shift-up", self.stop, ["down"])
        # rotate
        parent.accept("mouse3", self.move_camera)
        parent.accept("mouse3-up", self.stop_camera)

    def move(self, x, y, z, task_name):
        self.parent.taskMgr.add(self.move_task, task_name, extraArgs=[x, y, z])

    def move_task(self, x, y, z):
        self.parent.camera.setPos(self.parent.camera, x ,y ,z)
        return Task.cont

    def stop(self, task_name):
        self.parent.taskMgr.remove(task_name)

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
        self.parent.camera.setHpr(
            self.click_pos_h - diff_x * (self.sensitivity * 16),
            self.click_pos_p + diff_y * (self.sensitivity * 9),
            0
        )
        return Task.cont

    def stop_camera(self):
        self.parent.taskMgr.remove("move_camera")
