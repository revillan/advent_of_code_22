require 'pry'
require 'set'

input_path = File.join(File.dirname(__FILE__), '../inputs/day24.txt')
input = File.read(input_path)

sample = <<-TEXT
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
TEXT

class EscapeBlizzard
  def initialize(input)
    @max_y = input.split("\n").length - 1
    @max_x = input.split("\n").first.length - 1

    @blizzard_locations = Array.new(@max_x * @max_y)
    @blizzard_locations[0] = locate_blizzards(input)
    find_blizzard_periodicity

    @goal = [@max_x - 1, @max_y]
    @visited = {}
    @explore_queue = []
  end

  DIRS = {
    '^' => [0, -1],
    'v' => [0, 1],
    '<' => [-1, 0],
    '>' => [1, 0]
  }

  DIFFS = [[0,1], [0,-1], [1, 0], [-1, 0]]

  def locate_blizzards(input)
    locations = {} # location => direction
    input.split("\n").each_with_index do |row, i|
      row.split('').each_with_index do |cell, j|
        next if ['#', '.'].include?(cell)

        key = [j, i]
        locations[key] ||= []
        locations[key].push(cell)
      end
    end
    return locations
  end

  def adjust_for_walls(x, y)
    next_x, next_y = [x,y]
    if x == 0
      next_x = @max_x - 1
    elsif x == @max_x
      next_x = 1
    end
    
    if y == 0
      next_y = @max_y - 1
    elsif y == @max_y
      next_y = 1
    end
    
    return [next_x, next_y]
  end

  def next_blizzard_locations(locations)
    next_locations = {}
    
    locations.each do |location, directions|
      x, y = location
      directions.each do |arrow|
        diff_x, diff_y = DIRS[arrow]
        next_x = x + diff_x
        next_y = y + diff_y
        next_x, next_y = adjust_for_walls(next_x, next_y)

        key = [next_x, next_y]
        next_locations[key] ||= []
        next_locations[key].push(arrow)
      end
    end
    return next_locations
  end

  def blizzard_equality?(pos1, pos2)
    bliz1 = @blizzard_locations[pos1]
    bliz2 = @blizzard_locations[pos2]
    return false unless Set.new(bliz1.keys) == Set.new(bliz2.keys)

    bliz1.each do |location, blizzards|
      return false unless Set.new(bliz2[location]) == Set.new(blizzards)
    end
    return true
  end

  def find_blizzard_periodicity
    @period = nil
    minutes = 0
    while (!@period)
      minutes += 1
      @blizzard_locations[minutes] = next_blizzard_locations(@blizzard_locations[minutes-1])
      @period = minutes if blizzard_equality?(0, minutes)
    end
  end

  def reset_goal(new_goal)
    current_minutes = @visited[@goal].first
    @visited = {}
    @explore_queue = []
    @explore_queue.push([@goal, current_minutes])
    @goal = new_goal
  end

  def navigate_blizzards
    start = [1, 0]
    
    @explore_queue.push([start, 0])
    while (@explore_queue.length > 0 && !@visited[@goal]) do
      next_start, minutes = @explore_queue.shift
      find_quickest_route(next_start, minutes)
    end

    return @visited[@goal]
  end

  def navigate_blizzards_with_snack
    start = [1, 0]

    # To goal first time
    @explore_queue.push([start, 0])
    while (@explore_queue.length > 0 && !@visited[@goal]) do
      next_start, minutes = @explore_queue.shift
      find_quickest_route(next_start, minutes)
    end
    p @visited[@goal]

    # Back to entrance
    reset_goal(start)
    while (@explore_queue.length > 0 && !@visited[@goal]) do
      next_start, minutes = @explore_queue.shift
      # p @explore_queue
      find_quickest_route(next_start, minutes)
    end
    p @visited[@goal]

    # Back to goal
    reset_goal([@max_x - 1, @max_y])
    while (@explore_queue.length > 0 && !@visited[@goal]) do
      next_start, minutes = @explore_queue.shift
      find_quickest_route(next_start, minutes)
    end

    return @visited[@goal]
  end

  def find_quickest_route(start, minutes)
    return minutes if start == @goal
    
    next_minutes = minutes + 1
    next_blizzard = @blizzard_locations[next_minutes % @period]

    x, y = start
    DIFFS.each do |(diff_x, diff_y)|
      next_x = x + diff_x
      next_y = y + diff_y
      if next_x <= 0 || next_y <= 0
        next unless [next_x, next_y] == [1, 0]
      end
      if next_x >= @max_x || next_y >= @max_y
        next unless [next_x, next_y] == [@max_x - 1, @max_y]
      end
      blizzard_key = [next_x, next_y]
      next if next_blizzard[blizzard_key]

      @visited[blizzard_key] ||= []
      next if @visited[blizzard_key].include?(next_minutes)
      @visited[blizzard_key].push(next_minutes)
      @explore_queue.push([blizzard_key, next_minutes])
    end
    @explore_queue.push([start, next_minutes]) unless next_blizzard[start]
  end
end

## Part 1
puts EscapeBlizzard.new(sample).navigate_blizzards
puts EscapeBlizzard.new(input).navigate_blizzards

## Part 2
puts EscapeBlizzard.new(sample).navigate_blizzards_with_snack
puts EscapeBlizzard.new(input).navigate_blizzards_with_snack
