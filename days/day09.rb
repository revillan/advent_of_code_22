require 'pry'

input_path = File.join(File.dirname(__FILE__), '../inputs/day09.txt')
input = File.read(input_path)

sample = <<-TEXT
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
TEXT

sample_2 =  <<-TEXT
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
TEXT

def build_grid(m, n)
  grid = []
  m.times do 
    row = []
    n.times do
      row.push('.')
    end
    grid.push(row)
  end
  return grid
end

def display_grid(grid)
  grid.each do |row|
    puts row.join('')
  end
  puts ''
end

HEAD_MOVEMENTS = {
  'R' => [0,1],
  'L' => [0, -1],
  'U' => [-1, 0],
  'D' => [1, 0]
}

def map_movement(grid, head_x, head_y, input)
  directions = input.split("\n")
  grid[head_x][head_y] = 'H'
  tail_x, tail_y = [head_x, head_y]
  display_grid(grid)
  tail_positions = {}

  directions.each do |dir|
    direction, distance = dir.split(' ')
    distance = distance.to_i

    distance.times do
      diff = HEAD_MOVEMENTS[direction]
      grid[head_x][head_y] = '.'

      head_x = head_x + diff[0]
      head_y = head_y + diff[1]
      grid[head_x][head_y] = 'H'
      grid, tail_x, tail_y = check_tail_position(head_x, head_y, tail_x, tail_y, grid)
      key = [tail_x, tail_y].to_s
      tail_positions[key] = true
      display_grid(grid)
    end
  end
  return tail_positions.keys.count
end

def check_tail_position(head_x, head_y, tail_x, tail_y, grid)
  if ((head_x - tail_x).abs < 2 && (head_y - tail_y).abs < 2)
    return [grid, tail_x, tail_y]
  end
  grid[tail_x][tail_y] = '.' if grid[tail_x][tail_y] != 'H'

  if (head_x != tail_x)
    if head_x > tail_x
      tail_x += 1
    else
      tail_x -= 1
    end
  end
  if (head_y != tail_y)
    if head_y > tail_y
      tail_y += 1
    else
      tail_y -= 1
    end
  end
  grid[tail_x][tail_y] = 'T'
  [grid, tail_x, tail_y]
end

# grid = build_grid(5,6)
# input_grid = build_grid(200, 200)

# puts map_movement(input_grid, 100, 100, input)
# puts map_movement(grid, 4, 0, sample)

##### Part 2 

def map_movement(grid, head_x, head_y, input)
  directions = input.split("\n")
  grid[head_x][head_y] = 'H'
  tail_coords = []
  9.times do |i|
    tail_coords.push([head_x, head_y])
  end
  tail_x, tail_y = [head_x, head_y]
  display_grid(grid)
  tail_positions = {}

  directions.each do |dir|
    direction, distance = dir.split(' ')
    distance = distance.to_i

    distance.times do
      diff = HEAD_MOVEMENTS[direction]
      grid[head_x][head_y] = '.'

      head_x = head_x + diff[0]
      head_y = head_y + diff[1]
      grid[head_x][head_y] = 'H'

      
      1.upto(9) do |i|
        if i == 1
          first_x, first_y = [head_x, head_y]
        else
          first_x, first_y = tail_coords[i-2]
        end
        second_x, second_y = tail_coords[i-1]
        grid, mid_tail_x, mid_tail_y = check_tail_position(first_x, first_y, second_x, second_y, grid, i)
        tail_coords[i-1] = [mid_tail_x, mid_tail_y]
        if i == 9
          key = [mid_tail_x, mid_tail_y].to_s
          tail_positions[key] = true
        end
      end
      display_grid(grid)
    end
  end
  return tail_positions.keys.count
end

def check_tail_position(head_x, head_y, tail_x, tail_y, grid, sym)
  if ((head_x - tail_x).abs < 2 && (head_y - tail_y).abs < 2)
    return [grid, tail_x, tail_y]
  end

  if (head_x != tail_x)
    if head_x > tail_x
      tail_x += 1
    else
      tail_x -= 1
    end
  end
  if (head_y != tail_y)
    if head_y > tail_y
      tail_y += 1
    else
      tail_y -= 1
    end
  end
  grid[tail_x][tail_y] = sym if sym == 9
  [grid, tail_x, tail_y]
end


grid = build_grid(5,6)
grid_2 = build_grid(26, 50)
input_grid = build_grid(200, 200)

puts map_movement(input_grid, 100, 100, input)
# puts map_movement(grid, 4, 0, sample)
# puts map_movement(grid_2, 15, 15, sample_2)
