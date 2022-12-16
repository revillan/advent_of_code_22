require 'pry'
require 'set'

input_path = File.join(File.dirname(__FILE__), '../inputs/day16.txt')
input = File.read(input_path)

sample = <<-TEXT
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
TEXT


class Tunnels
  def initialize(input)
    set = {}
    flow_rates = {}
  
    input.split("\n").each do |line|
      ln_arr = line.split(' ')
      name = ln_arr[1]
      rate = ln_arr[4].split('=').last.to_i
      flow_rates[name] = rate if rate > 0
      set[name] = {}
      list = ln_arr.slice(9, ln_arr.length).join(' ').split(', ')
      set[name] = list
    end
    @set = set
    @rates = flow_rates
    @max_pressure = 0
    @combo_max_pressure = 0 

    @pos_rate_set = {}
    @rates.keys.concat(["AA"]).each do |pos_valve|
      @pos_rate_set[pos_valve] = dist_between_pos(pos_valve)
    end
  end
  
  def dist_between_pos(location)
    explored = {}
    explored[location] = 0
    queue = []
    queue.push(location)
    while (queue.length > 0) do 
      current = queue.shift
      @set[current].each do |neighbor|
        next if explored[neighbor]

        explored[neighbor] = (explored[current] + 1)
        queue.push(neighbor)
      end
    end
    return explored.select { |k,_| @rates.keys.include?(k) }
  end

  def all_paths
    open_valves = {}
    location = "AA"
    open_valves[location] = true
    minutes = 30

    recurse_path(location, minutes, 0, open_valves)
    return @max_pressure
  end

  def explore_with_elephant
    open_valves = {}
    location = "AA"
    open_valves[location] = true
    minutes = 26

    to_visit = @pos_rate_set.select {|k,_| k != "AA" }.keys
    half_size = to_visit.size / 2
    combos = []
    (half_size - 1).upto(half_size) do |i|
      combos.concat(to_visit.combination(i).to_a)
    end
    to_visit = to_visit.to_set
    @max_pressure = 0

    combos.each do |com| 
      you_visit = com
      elephant_visits = (to_visit - com.to_set).to_a

      you_valves = open_valves.clone
      elephant_valves = open_valves.clone
      you_visit.each { |place| elephant_valves[place] = true }
      elephant_visits.each { |place| you_valves[place] = true }

      recurse_path(location, minutes, 0, you_valves)
      you_pressure = @max_pressure
      @max_pressure = 0 

      recurse_path(location, minutes, 0, elephant_valves)
      elephant_pressure = @max_pressure
      @max_pressure = 0

      total_pressure = you_pressure + elephant_pressure 
      @combo_max_pressure = total_pressure if (total_pressure > @combo_max_pressure)
    end
    return @combo_max_pressure
  end
  
  def recurse_path(location, minutes, pressure, open_valves)
    if minutes <= 0
      @max_pressure = pressure if pressure > @max_pressure
      return
    end

    new_minutes = minutes - 1

    # open
    if open_valves[location].nil? && @rates[location]
      new_pressure = (new_minutes * @rates[location] + pressure)
      new_open_valves = open_valves.clone
      new_open_valves[location] = true
      recurse_path(location, new_minutes, new_pressure, new_open_valves)
    else
      # move
      @pos_rate_set[location].each do |next_loc, dist|
        next if open_valves[next_loc]
        move_minutes = minutes - dist
        next if (minutes - move_minutes) < 0
        recurse_path(next_loc, move_minutes, pressure, open_valves)
      end
    end
    @max_pressure = pressure if pressure > @max_pressure
  end
end

samp_inst = Tunnels.new(sample)
puts samp_inst.all_paths # part 1
puts samp_inst.explore_with_elephant # part 2

puzzle_inst = Tunnels.new(input)
puts puzzle_inst.all_paths # part 1
puts puzzle_inst.explore_with_elephant # part 2