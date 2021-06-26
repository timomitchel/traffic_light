class Intersection

  attr_reader :pairs, :ticks
  def initialize(pairs)
    @pairs = pairs
    @ticks = 0
    turn_all_red
  end

  def current_state
    @pairs.each do |key, value|
      value.each_with_index do |light, index|
        puts "#{key[index]} #{light.color}"
      end
    end
  end

  def turn_all_red
    @pairs.each do |key, value|
      value.each do |light|
        light.set_color('red')
      end
    end
  end

  def turn_lights(direction, color)
    @pairs[direction].each do |light|
      light.set_color(color)
    end
  end

  def find_lights(color)
    current_light_state = @pairs.values.flatten.find_all do |light|
      light.color == color
    end
    return nil if current_light_state.length != 2
    @pairs.key(current_light_state)
  end

  def switch_light_state(direction)
   turn_lights(direction, switch_check)
  end

  def emergency_shutdown
    current_greens = find_lights('green')
    turn_all_red
    if current_greens.nil?
      increment_tick(50)
      reset_tick(0)
      switch_light_state(@pairs.keys.sample)
    else
      increment_tick(50)
      reset_tick(0)
      switch_light_state(current_greens)
    end
  end

  def switch_check
    return 'yellow' if @ticks == 30
    return 'red' if @ticks == 33
    return 'green' if @ticks == 0
  end

  def increment_tick(tick_interval)
    tick_interval.times do
      @ticks += 1
    end
  end

  def reset_tick(tick_interval = 0)
    @ticks = tick_interval
  end
end
# When one pair is green or yellow, the other pair has to be red.
#
# Required general program features:
# A way to initialize the controller with the 4 lights for a 2 way intersection, hooked up in pairs
# A way to trigger a tick to step through the state of the controller (in the real world this would be hooked up to a periodic timer)
# A way to print out (or output in some way) the current state of the lights for the intersection/controller.
# Could be as simple as L1: G, L2: R, L3: G, L4: R but totally up to you.
# A way to configure how long the lights stay green & yellow for (eg 30 ticks green, 3 ticks yellow)
# Some way to run/test/output a full light cycle though all the steps/ticks.
# Design:
# Design a data model to represent the intersection. Then implement a way to print out the current state of
# the lights in the intersection.
# An intersection where both pairs of traffic lights have the same timing cycle. e.g.
# One pair of lights (Pair A) stays green for 5 ticks, then yellow for 2 ticks, then red.
# Then the other pair of lights (Pair B) goes green for 5 ticks, then yellow for 2 ticks, then red.
# An "emergency override" on the controller that makes all lights red for X ticks, to allow ambulances and other emergency
# vehicles to temporarily shut down the intersection.
# After X ticks have passed, the intersection should continue stepping through the light sequence from the point where it left off.
# Add left turn arrows to the cycle. Both roads in the intersection should have a left turn indicator in their light cycle.
