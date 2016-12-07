from math import pi, sin, cos

from panda3d.core import GeomVertexFormat, GeomVertexData
from panda3d.core import Geom, GeomTriangles, GeomVertexWriter, GeomNode

def planet():
    #step 1) create GeomVertexData and add vertex information
    format = GeomVertexFormat.getV3()
    vdata = GeomVertexData("vertices", format, Geom.UHDynamic)

    vertexWriter = GeomVertexWriter(vdata, "vertex")
    vertexWriter.addData3f(0,1,0)   # center of circle

    #step 2) make primitives and assign vertices to them
    tris = GeomTriangles(Geom.UHDynamic)
    i3 = 0
    points = 20
    for i, x, y in circle(points, 10):
        for i2, x2, y2 in circle(points, y):
            i3 += 1
            vertexWriter.addData3f(x,y2,x2)
            tris.addVertices(0 if i==0 else i3-points, i3-1, i3)
            tris.addVertices(i3-1, 0 if i==0 else i3 - points+1, i3)

    #step 3) make a Geom object to hold the primitives
    squareGeom = Geom(vdata)
    squareGeom.addPrimitive(tris)

    #now put squareGeom in a GeomNode. You can now position your geometry in the scene graph.
    squareGN=GeomNode("square")
    squareGN.addGeom(squareGeom)
    return squareGN

def circle(points, scale):
    angle = (360 / points) * (pi / 180.0)
    i = 0
    while angle * i < 360 * (pi / 180):
        x = sin(angle * i) * scale
        y = cos(angle * i) * scale
        yield (i, x, y)
        i += 1
