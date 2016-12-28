Creating a World Generation Module
==================================
In LAO, the algorithm that generates your planets can be totally customised
and modularly replaced. This document will explain the basic requirements
of each planet generation module so that you can be sure that your module will
fit right in with the LAO universe.

General I/O
----------
A planet generator is a function that takes the following parameters:

`size`: Indicates the scale of the planets diameter in comparison to other planets

`base_seed`: Gives you a seed to use for all random generation.

As for output, the generator must simply output a geom shape to be placed in the
desired location of your planet
