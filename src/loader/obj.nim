import ../common/mesh
import ../common/model

import streams
import strutils

proc loadObjFromStream*(s: Stream): Model =
  var
    model = new Model
    line: string = ""
    cur_mesh_id: int = -1

  # echo s

  while s.readLine(line):
    line = line.strip()
    # skip empty lines
    if line.len == 0:
      continue

    let
      parts = line.split(" ")

    let
      line_type = parts[0]
      args = parts[1..<parts.len]
    case line_type
    of "#":
      # it's a comment, ignore it
      discard
    of "mtllib":
      # do something here to do with mtl
      discard
    of "usemtl":
      # some more mtl stuff
      discard
    of "s":  # smooth shading flag
      if args[0] == "off":
        model.meshes[cur_mesh_id].setSmoothShading(false)
      else:
        model.meshes[cur_mesh_id].setSmoothShading(true)

      discard
    of "o":
      cur_mesh_id = model.createNewMesh(args[0])
    of "v":
      let
        v_0 = parseFloat(args[0])
        v_1 = parseFloat(args[1])
        v_2 = parseFloat(args[2])
      model.meshes[cur_mesh_id].addVertex(v_0, v_1, v_2)
    of "vt":
      let
        vt_0 = parseFloat(args[0])
        vt_1 = parseFloat(args[1])
      model.meshes[cur_mesh_id].addTextureVertex(vt_0, vt_1)
    of "vn":
      let
        vn_0 = parseFloat(args[0])
        vn_1 = parseFloat(args[1])
        vn_2 = parseFloat(args[2])
      model.meshes[cur_mesh_id].addNormalVertex(vn_0, vn_1, vn_2)
    of "f":
      # f v1 v2 v3
      # f v1/vt1 v2/vt2 v3/vt3
      # f v1/vt1/vn1 v2/vt2/vn2 v3/vt3/vn3
      # f v1//vn1 v2//vn2 v3//vn3

      var
        indices, uvMaps, normalMaps: seq[cint]

      indices = @[]
      uvMaps = @[]
      normalMaps = @[]

      for arg in args:
        let
          block_args = arg.split("/")

        if block_args.len >= 1:
          indices.add((cint)parseInt(block_args[0]))
          # indices.add((cint)parseInt(block_args[0]))
        if block_args.len >= 2:
          if block_args[1] != "":
            uvMaps.add((cint)parseInt(block_args[1]))
        if block_args.len == 3:
          normalMaps.add((cint)parseInt(block_args[2]))

      # echo indices, uvMaps, normalMaps
      if indices.len != 0:
        model.meshes[cur_mesh_id].addIndice(indices[0], indices[1], indices[2])
      if uvMaps.len != 0:
        model.meshes[cur_mesh_id].addTextureIndice(uvMaps[0], uvMaps[1], uvMaps[2])
      if normalMaps.len != 0:
        model.meshes[cur_mesh_id].addNormalIndice(normalMaps[0], normalMaps[1], normalMaps[2])

    else:
      discard

  return model


proc loadObjFromFile*(filepath: string): Model =
  let
    f = open(filepath)
    fs = newFileStream(f)

  return loadObjFromStream(fs)
