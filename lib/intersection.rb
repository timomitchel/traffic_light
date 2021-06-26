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
    emergency_tick_count
    if current_greens.nil?
      switch_light_state(@pairs.keys.sample)
    else
      switch_light_state(current_greens)
    end
  end

  def emergency_tick_count
    increment_tick(50)
    reset_tick(0)
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
