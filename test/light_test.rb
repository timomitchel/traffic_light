require 'minitest/pride'
require 'minitest/autorun'
require './lib/light'

class LightTest < Minitest::Test

  def setup
    @light = Light.new

  end

  def test_it_exists
    assert_instance_of Light, @light
  end

  def test_atttributes
    assert_nil @light.color
  end

  def test_we_can_set_color
    assert_nil @light.color

    @light.set_color("green")
    assert_equal @light.color, "green"
    @light.set_color("yellow")
    assert_equal @light.color, "yellow"
    @light.set_color("red")
    assert_equal @light.color, "red"
  end

end
