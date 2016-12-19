Logic Art Online
================
Logic Art Online(LAO) is a (in development) multiplayer video game. It is
intended to be the ultimate creative survival and strategy game. You start on a
planet and must build automated systems of machines to gather resources in order
to improve the capabilities of your creations. Program your machines to run your
civilisation, explore landscapes, and defend itself from invading players. Use
the wealth of your thriving civilisation to build crazy contraptions and
dominate the infinitely generated universe!

Game Mechanics
--------------
Your character spawns with an (yet to be named) interface on their wrist. Use
this interface to design your own machines and either print them, or store them
as blueprints. Place resources into a science lab to research your available
technology and improve it. Create the machines required to gather those
materials and to keep you alive and safe.

Building machines
-----------------
Building machines can be done from the (yet to be named) wrist interface. Create
and save custom shapes called `sections`, then stick multiple sections together
to create a skeleton for your machine. Assign properties to each section to
make that section into a `component`. You can also decide the resource you want
to use to print each component/section. The size of the component, and the
resource it is made from will determine things like its power usage,
effectiveness, weight, and resistance to damage.

Component properties
------------------
You are given all properties by default, but they will probably need to be
upgraded to fit the requirements of your more ambitious ideas. For example, an
un-upgraded thruster will require a lot of energy and provide very little
thrust. Upgrades can then be applied to improve the efficiency of the thruster.
Below is a list of all planned properties:

### Movement
Adding these properties to a section will provide the machine with movement.
- thruster
  - consumes energy to generate directional thrust.
- motor
  - consumes energy and spins connected objects in the target direction.
- servo
  - like a motor, but is controlled by degree as opposed to RPM.
  - may be merged with the motor at a later stage.
- piston
  - consumes energy to grow larger in the target direction.
- propeller
  - produces directional thrust when spun with motor.
  - low-level alternative to thrusters.
  - does not work in vacuum.
- conveyor
  - pushes items along the selected faces in target direction

### Electrical
Properties that provide in-game functionality to your machine.
- button
  - can be operated in game.
  - state can be referenced in circuit code.
- switch
  - can be operated in game.
  - state can be referenced in circuit code.
- text display
  - displays sent text on selected faces.
  - may be merged with display.
  - consumes energy
- display
  - renders a stream of pixels to selected faces.
  - consumes energy
- printer
  - uses resources to form in game objects.
  - can be used to print from blueprints.
  - upgrades improve print speed.
  - component does not clip with other objects and is transparent
  - component can have only one connection to avoid abuse of no-clip
  - consumes energy.
- recycler/unprinter
  - just like the printer but in reverse
  - takes items from interior area and yields back the print cost resources.
  - consumes energy.
- drill/quarry
  - similar to printer in physical properties
  - used to harvest minerals from ground below.
  - consumes energy.
  - different locations provide different resources and quantities.
- science lab
  - when turned on, will consume resources from a nearby inventory
  - each consumed resource grants exp

### Physical
Provides components with in-game effects.
- sharp
  - colliding objects will take damage based on momentum
- harvest
  - consumes energy to harvest nearby crops
- planter
  - places seeds from inventory into nearby fertile ground.
  - consumes energy.
- fertilizer
  - increases fertility of nearby ground.
  - increases the growth rate of nearby crops.
  - consumes energy.
- hinge
 - connected objects swing at their connection point with this component.
 - axis of swing can be locked.

### Energy
- generator/reactor
  - uses items in inventory to produce power
  - different items produce varying levels of power
- battery
  - stores power for later consumption.
- power supply
  - used to share power with other devices by connecting cables in game

### Items and Inventory
- storage unit
  - used to store items
- dropper
  - drops items from inventory into the game world from selected face
- hopper
  - collects nearby items
