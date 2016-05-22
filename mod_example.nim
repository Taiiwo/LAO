import math

proc `mod` (a, b: int): int {. noSideEffect .} =
  return a - (int)(floor(a / b)) * b

proc main() =
  echo 9 mod 2

main()
