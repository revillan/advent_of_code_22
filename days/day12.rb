require 'pry'

input_path = File.join(File.dirname(__FILE__), '../inputs/day12.txt')
input = File.read(input_path)

sample = <<-TEXT
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
TEXT

def parse_grid(str)
  grid = []
  start, goal = [nil, nil]
  str.split("\n").each_with_index  do |row, i|
    line = []
    row.split('').map.with_index do |letter, j|
      if letter == "S"
        start = [i, j]
        line.concat("a".bytes)
      elsif letter == "E"
        goal = [i, j]
        line.concat("z".bytes)
      else
        line.concat(letter.bytes)
      end
    end
    grid.push(line)
  end
  return [grid, start, goal]
end

def path_start_to_end(str) # part 1
  grid, start, goal = parse_grid(str)
  return bfs(grid, start, goal)
end

def find_all_a(grid)
  a_elevations = []
  low = "a".bytes.first
  grid.each_with_index do |row, i|
    row.each_with_index do |elevation, j|
      a_elevations.push([i,j]) if elevation == low
    end
  end
  return a_elevations
end

def shortest_steps(input)
  grid, start, goal = parse_grid(input)
  a_starts = find_all_a(grid)
  steps = []
  a_starts.each do |low_start|
    steps.push(bfs(grid, low_start, goal))
  end
  return steps.compact.min
end

DIFFS = [[0,1], [0,-1], [1, 0], [-1, 0]]
def bfs(grid, start, goal)
  curx, cury = start
  explored = {}
  
  explored[start] = {}
  explored[start][:dist] = 0

  queue = [start]
  
  while (queue.length > 0) do
    current = queue.shift
    curx, cury = current
    cur_elevation = grid[curx][cury]
    DIFFS.each do |diff|
      nextx = diff[0] + curx
      nexty = diff[1] + cury
      next if (nextx < 0 || nexty < 0)
      next if (nextx >= grid.length || nexty >= grid[0].length)

      key = [nextx, nexty]
      next if explored[key]
      next if grid[nextx][nexty] > cur_elevation + 1
      explored[key] = {}
      explored[key][:dist] = explored[current][:dist] + 1
      break if key == goal
      queue.push(key)
    end
  end
  return nil unless explored[goal]
  return explored[goal][:dist]
end

# part 1
puts path_start_to_end(sample)
puts path_start_to_end(input)

puts "~~~~~"

# part 2
puts shortest_steps(sample)
puts shortest_steps(input)