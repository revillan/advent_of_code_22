require 'pry'

input_path = File.join(File.dirname(__FILE__), '../inputs/day23.txt')
input = File.read(input_path)

tiny_sample = <<-TEXT
.....
..##.
..#..
.....
..##.
.....
TEXT

sample = <<-TEXT
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
TEXT

def display_grid(grid)
  grid.each do |row|
    puts row.join('')
  end
  puts ''
end

def create_grid(input, buffer)
  grid = []
  split_input = input.split("\n")
  buffer_arr = Array.new(split_input.first.length + (2 * buffer)).fill('.')
  split_input.each_with_index do |row, i|
    buffer.times { grid.push(buffer_arr) } if i == 0
    line = []
    buffer.times { line.push('.') }
    row.split('').each_with_index do |cell, j|
      line.push(cell)
    end
    buffer.times { line.push('.') }
    grid.push(line)
    buffer.times { grid.push(buffer_arr) } if i == split_input.length - 1
  end
  return grid
end

DIFFS = [[0,-1], [0,1], [-1,0], [1,0],] # N, S, W, E
def first_half_round(grid, round_number)
  where_to_move = {}
  no_move = []
  diffs_start = round_number % 4
  grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      next unless cell == '#'

      # check neighbors
      neighbors_count = 0
      -1.upto(1) do |diff_y|
        -1.upto(1) do |diff_x|
          next if diff_x == 0 && diff_y == 0
          y = i + diff_y
          x = j + diff_x
          neighbors_count += 1 if grid[y][x] == '#'
        end
      end

      if neighbors_count == 0 || neighbors_count > 6
        no_move.push([j, i]) # x, y
        next
      end

      proposed_move = false
      times = 0
      dirs = diffs_start
      while (!proposed_move) do
        diff_x, diff_y = DIFFS[dirs]
        neighbors = 0
        if diff_x == 0
          (-1).upto(1) do |ew|
            y = i + diff_y
            x = j + ew
            neighbors +=1 if grid[y][x] =='#'
          end
        elsif diff_y == 0
          (-1).upto(1) do |nw|
            x = j + diff_x
            y = i + nw
            neighbors +=1 if grid[y][x] =='#'
          end
        end
        if neighbors == 0
          proposed_move = true
          new_x = j + diff_x
          new_y = i + diff_y
          new_location = [new_x, new_y]
          where_to_move[new_location] ||= []
          where_to_move[new_location].push([j,i])
        end
        dirs = (dirs + 1) % 4
        times += 1
        if times > 4
          no_move.push([j, i])
          break
        end
      end
    end
  end
  return [where_to_move, no_move]
end

def second_half_round(grid, where_to_move, no_move)
  next_grid = Array.new(grid.length) { Array.new(grid.first.length).fill('.') }
  no_move.each do |(x,y)|
    next_grid[y][x] = '#'
  end

  where_to_move.each do |new_location, old_locations|
    if old_locations.length == 1
      x, y = new_location
      next_grid[y][x] = '#'
    else
      old_locations.each do |(x,y)|
        next_grid[y][x] = '#'
      end
    end
  end
  return next_grid
end

def count_empty_spaces_in_min_grid(grid)
  min_x, min_y = [grid.first.length, grid.length]
  max_x, max_y = [0, 0]

  grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      next unless cell == '#'

      min_x = j if j < min_x
      min_y = i if i < min_y
      max_x = j if j > max_x
      max_y = i if i > max_y
    end
  end

  empty_spaces = 0
  min_y.upto(max_y) do |y|
    min_x.upto(max_x) do |x|
      empty_spaces += 1 if grid[y][x] == '.'
    end
  end
  return empty_spaces
end

def spread_out_elves(input, buffer, rounds)
  grid = create_grid(input, buffer)
  display_grid(grid)

  rounds.times do |round_count|
    where_to_move, no_move = first_half_round(grid, round_count)
    grid = second_half_round(grid, where_to_move, no_move)
  end
  display_grid(grid)

  return count_empty_spaces_in_min_grid(grid)
end

def rounds_til_spread_out(input, buffer)
  grid = create_grid(input, buffer)
  display_grid(grid)
  continue_rounds = true
  rounds = 0

  while (continue_rounds)
    where_to_move, no_move = first_half_round(grid, rounds)
    grid = second_half_round(grid, where_to_move, no_move)
    rounds += 1
    continue_rounds = false if where_to_move.keys.length == 0
  end
  display_grid(grid)

  return rounds
end

## Part 1
puts spread_out_elves(sample, 7, 20)
puts spread_out_elves(input, 10, 10)

## Part 2
puts rounds_til_spread_out(sample, 7)
puts rounds_til_spread_out(input, 70)
