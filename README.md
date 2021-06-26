## Intersection Challenge

[Design a traffic light controller](https://gist.github.com/arlandism/c87233bf17845d4f89bf6f09da84550d)

When one pair is green or yellow, the other pair has to be red.

Required general program features:

- A way to initialize the controller with the 4 lights for a 2 way intersection, hooked up in pairs
- A way to trigger a tick to step through the state of the controller (in the real world this would be hooked up to a periodic timer)
- A way to print out (or output in some way) the current state of the lights for the intersection/controller.
  - Could be as simple as L1: G, L2: R, L3: G, L4: R but totally up to you.
A way to configure how long the lights stay green & yellow for (eg 30 ticks green, 3 ticks yellow)
- Some way to run/test/output a full light cycle though all the steps/ticks.

### Design:
- Design a data model to represent the intersection. Then implement a way to print out the current state of the lights in the intersection.
- An intersection where both pairs of traffic lights have the same timing cycle. e.g.
- One pair of lights (Pair A) stays green for 5 ticks, then yellow for 2 ticks, then red.
- Then the other pair of lights (Pair B) goes green for 5 ticks, then yellow for 2 ticks, then red.
- An "emergency override" on the controller that makes all lights red for X ticks, to allow ambulances and other emergency vehicles to temporarily shut down the intersection.
- After X ticks have passed, the intersection should continue stepping through the light sequence from the point where it left off.
