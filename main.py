from math import pi, sin, cos

from direct.showbase.ShowBase import ShowBase
from direct.task import Task
from direct.actor.Actor import Actor
from direct.interval.IntervalGlobal import Sequence
from panda3d.core import Point3
from panda3d.core import PerspectiveLens
from panda3d.core import Light, Spotlight

import fly_camera
import planet_generator

class LAO(ShowBase):

    def __init__(self):
        ShowBase.__init__(self)

        # Disable the camera trackball controls.
        self.disableMouse()

        render.setShaderAuto()



        # Load the environment model.
        self.scene = planet_generator.planet()
        # Reparent the model to render.
        planet = self.render.attachNewNode(self.scene)
        # Apply scale and position transforms on the model.
        planet.setScale(5, 5, 5)
        planet.setTwoSided(True)

        slight = Spotlight('slight')
        slight.setColor((1, 1, 1, 1))
        lens = PerspectiveLens()
        slight.setLens(lens)
        self.slnp = render.attachNewNode(slight)
        self.slnp1 = render.attachNewNode(slight)
        self.slnp.setPos(planet, 0, 0, 100)
        self.slnp.lookAt(0, 0, 0)
        render.setLight(self.slnp)

        # sets the fly camera
        fly_camera.FlyCamera(self, 1, 2)

app = LAO()
app.run()
