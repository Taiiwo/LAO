# import ../common/model
import typetraits

type
  GateKind = enum
    gateTrue,
    gateFalse,
    gateNot,
    gateAnd,
    gateOr,
    gateNand,
    gateNor,
    gateXor,
    gateXnor

  Gate* = object of RootObj
    # model*: Model
    case kind: GateKind
    of gateTrue, gateFalse:
      nil
    of gateNot, gateAnd, gateOr, gateNand, gateNor, gateXor, gateXnor:
      inputs*: seq[Gate]

proc output*(gate: Gate): bool =
  case gate.kind:
    of gateTrue:
      return true

    of gateFalse:
      return false

    of gateNot:
      return gate.inputs[0].output

    of gateAnd:
      for input in gate.inputs:
        if input.output == false:
          return false
      return true

    of gateOr:
      for input in gate.inputs:
        if input.output == true:
          return true
      return false

    of gateNand:
      for input in gate.inputs:
        if input.output == false:
          return true
      return false

    of gateNor:
      for input in gate.inputs:
        if input.output == true:
          return false
      return true

    of gateXor:
      var got_true = false
      for input in gate.inputs:
        if input.output == true:
          if got_true == true:
            return false
          else:
            got_true = true
      return got_true

    of gateXnor:
      var got_true = false
      for input in gate.inputs:
        if input.output == true:
          if got_true == true:
            return true
          else:
            got_true = true
      return not got_true

proc main*(): int =
  var truegate = Gate(kind: GateKind.gateTrue)
  var falsegate = Gate(kind: GateKind.gateFalse)

  var andgatetrue = Gate(kind: GateKind.gateAnd, inputs: @[truegate, truegate])
  var andgatefalse = Gate(kind: GateKind.gateAnd, inputs: @[truegate, falsegate])
  assert andgatetrue.output == true
  assert andgatefalse.output == false

  echo "test passed!"
  return 0

discard main()
