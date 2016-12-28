from random import uniform
from math import pi, sin, cos, radians, degrees
from panda3d.core import GeomVertexFormat, GeomVertexData
from panda3d.core import Geom, GeomTriangles, GeomVertexWriter, GeomNode

def planet(size, base_seed):
    #step 1) create GeomVertexData and add vertex information
    format = GeomVertexFormat.getV3()
    vdata = GeomVertexData("vertices", format, Geom.UHDynamic)

    vertexWriter = GeomVertexWriter(vdata, "vertex")
    vertexWriter.addData3f(0,10,0)   # center of circle

    #step 2) make primitives and assign vertices to them
    tris = GeomTriangles(Geom.UHDynamic)
    i3 = 0
    points = 50
    # for each point in a circle
    for i, x, y in circle(points * 2, 10):
        # for each point in another circle where the radius is the x coord of
        # the point in the parent loop
        for i2, x2, y2 in circle(points * 2, x):
            # stop after doing a semicircle
            if i2 > points:
                break
            # Used to keep track of the current vertex. Start at one because we
            # already made our initial vertex at the center of the first face
            i3 += 1
            # draw a vertex at this location
            # x is the same for each of these, and we use the x y coords from
            # the circle as y z coords.
            vertexWriter.addData3f(y2, x2, y)
            if i == 0:
                if i2 == 0:
                    # skip the first point
                    continue
                # on the first circle, link everything to 0
                tris.addVertices(0, i3-1, i3)
            else:
                # for each point we draw two triangles.
                # the first triangle connects the current point, the previous point
                # and a point from the previous layer inline with the current point
                tris.addVertices(i3-points-1, i3-1, i3)
                # the second triangle goes from the previous point to the point
                # inline with the current point on the previous layer, and the point
                # before that
                tris.addVertices(i3, i3-points-1, i3-points)

    #step 3) make a Geom object to hold the primitives
    squareGeom = Geom(vdata)
    squareGeom.addPrimitive(tris)

    #now put squareGeom in a GeomNode. You can now position your geometry in the scene graph.
    squareGN=GeomNode("square")
    squareGN.addGeom(squareGeom)
    return squareGN

def circle(points, scale):
    separation = 2*pi/points
    i = 0
    angle = separation * i
    while angle < 2*pi:
        x = sin(angle) * scale
        y = cos(angle) * scale
        yield (i, x, y)
        i += 1
        angle = separation * i
    x = sin(angle) * scale
    y = cos(angle) * scale
    yield (i, x, y)
