require 'minitest/pride'
require 'minitest/autorun'
require 'mocha/minitest'
require './lib/light'
require './lib/intersection'

class IntersectionTest < Minitest::Test

  def setup
    @north = Light.new
    @south = Light.new
    @east = Light.new
    @west = Light.new

    pairs = {
      :ns => [@north, @south],
      :ew => [@east, @west]
    }

    @intersection = Intersection.new(pairs)
  end

  def test_intersection_attibutes
    assert_equal @intersection.pairs.keys, [:ns, :ew]
    assert_equal @intersection.pairs.values, [[@north, @south], [@east, @west]]
    assert_equal @intersection.ticks, 0
  end

  def test_default_state_of_lights_is_red
     @intersection.pairs[:ns].each do |light|
       assert_equal light.color, "red"
    end

    @intersection.pairs[:ew].each do |light|
      assert_equal light.color, "red"
   end
  end

  def test_turn_ns_green
    @intersection.turn_lights(:ns, 'green')
      @intersection.pairs[:ns].each do |light|
        assert_equal light.color, "green"
     end

     @intersection.pairs[:ew].each do |light|
       assert_equal light.color, "red"
    end
  end

  def test_tick_incrementer
    @intersection.increment_tick(30)
    assert_equal @intersection.ticks, 30
  end

  def test_switch_check
    assert_equal 'green', @intersection.switch_check
    @intersection.increment_tick(30)
    assert_equal 'yellow', @intersection.switch_check
    @intersection.increment_tick(3)
    assert_equal 'red', @intersection.switch_check
  end

  def test_turn_ew_green_based_on_switch_check
    @intersection.switch_light_state(:ew)
    @intersection.pairs[:ew].each do |light|
      assert_equal light.color, "green"
   end

     @intersection.pairs[:ns].each do |light|
       assert_equal light.color, "red"
    end
  end

  def test_increment_ew_through_all_states
    @intersection.switch_light_state(:ew)
    @intersection.increment_tick(30)
    @intersection.switch_light_state(:ew)
    @intersection.pairs[:ew].each do |light|
      assert_equal light.color, "yellow"
   end

     @intersection.pairs[:ns].each do |light|
       assert_equal light.color, "red"
    end

    @intersection.increment_tick(3)
    @intersection.switch_light_state(:ew)
    @intersection.pairs[:ew].each do |light|
      assert_equal light.color, "red"
   end

     @intersection.pairs[:ns].each do |light|
       assert_equal light.color, "red"
    end
  end

  def test_increment_ns_through_all_states
    @intersection.switch_light_state(:ns)
    @intersection.increment_tick(30)
    @intersection.switch_light_state(:ns)
    @intersection.pairs[:ns].each do |light|
      assert_equal light.color, "yellow"
   end

     @intersection.pairs[:ew].each do |light|
       assert_equal light.color, "red"
    end

    @intersection.increment_tick(3)
    @intersection.switch_light_state(:ns)
    @intersection.pairs[:ns].each do |light|
      assert_equal light.color, "red"
   end

     @intersection.pairs[:ew].each do |light|
       assert_equal light.color, "red"
    end
  end

  def test_reset_tick
    @intersection.increment_tick(30)
    @intersection.increment_tick(3)
    @intersection.reset_tick(0)
    assert_equal @intersection.ticks, 0
    @intersection.switch_light_state(:ns)
    assert_equal @intersection.ticks, 0
    @intersection.pairs[:ns].each do |light|
      assert_equal light.color, "green"
   end
     @intersection.pairs[:ew].each do |light|
       assert_equal light.color, "red"
    end
  end

  def test_full_cycle
    @intersection.switch_light_state(:ew)
    @intersection.increment_tick(30)
    @intersection.switch_light_state(:ew)
    @intersection.pairs[:ew].each do |light|
      assert_equal light.color, "yellow"
   end

     @intersection.pairs[:ns].each do |light|
       assert_equal light.color, "red"
    end

    @intersection.increment_tick(3)
    @intersection.switch_light_state(:ew)
    @intersection.pairs[:ew].each do |light|
      assert_equal light.color, "red"
   end

     @intersection.pairs[:ns].each do |light|
       assert_equal light.color, "red"
    end

    @intersection.reset_tick(0)
    @intersection.switch_light_state(:ns)
    @intersection.increment_tick(30)
    @intersection.switch_light_state(:ns)
    @intersection.pairs[:ns].each do |light|
      assert_equal light.color, "yellow"
   end

     @intersection.pairs[:ew].each do |light|
       assert_equal light.color, "red"
    end

    @intersection.increment_tick(3)
    @intersection.switch_light_state(:ns)
    @intersection.pairs[:ns].each do |light|
      assert_equal light.color, "red"
   end

     @intersection.pairs[:ew].each do |light|
       assert_equal light.color, "red"
    end
  end

  def test_find_lights_of_specific_color
    assert_nil @intersection.find_lights('red')
    assert_nil @intersection.find_lights('green')
    assert_nil @intersection.find_lights('yellow')
    @intersection.increment_tick(30)
    @intersection.switch_light_state(:ns)
    assert_equal :ns, @intersection.find_lights('yellow')
    @intersection.increment_tick(3)
    @intersection.switch_light_state(:ns)
    assert_nil @intersection.find_lights('red')
    @intersection.reset_tick
    @intersection.switch_light_state(:ew)
    assert_equal :ns, @intersection.find_lights('red')
  end

  def test_emergency_shutdown_with_lights_green
    @intersection.switch_light_state(:ns)
    @intersection.emergency_shutdown

    @intersection.pairs[:ns].each do |light|
      assert_equal light.color, "green"
   end
     @intersection.pairs[:ew].each do |light|
       assert_equal light.color, "red"
    end
  end

  def test_emergency_shutdown_with_lights_yellow
    @intersection.increment_tick(30)
    @intersection.switch_light_state(:ns)

    Array.any_instance.stubs(:sample).returns(:ew)
    @intersection.emergency_shutdown
    @intersection.pairs[:ew].each do |light|
        assert_equal light.color, "green"
     end
     @intersection.pairs[:ns].each do |light|
        assert_equal light.color, "red"
    end
  end

  def test_emergency_shutdown_with_lights_red
    Array.any_instance.stubs(:sample).returns(:ew)
    @intersection.emergency_shutdown
    @intersection.pairs[:ew].each do |light|
        assert_equal light.color, "green"
     end
     @intersection.pairs[:ns].each do |light|
        assert_equal light.color, "red"
    end
  end
end
