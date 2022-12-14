require 'pry'
input_path = File.join(File.dirname(__FILE__), '../inputs/day14.txt')
input = File.read(input_path)

sample = <<-TEXT
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
TEXT

def display_grid(grid)
  grid.each do |row|
    puts row.join('')
  end
  puts ''
end

YMIN_EX = 494 
YMIN = 490
def draw_grid(example, part)
  xmin = 0
  xmax = example ? 9 : 162
  ymin = example ? YMIN_EX : YMIN
  ymax = example ? 503 : 563
  if part == 2
    xmax += 2
    ymax += 150
    ymin -= 150
  end
  grid = []
  xmin.upto(xmax) do |row|
    line = []
    ymin.upto(ymax) do |col|
      line.push('.')
    end
    grid.push(line)
  end
  grid.last.fill('#') if part == 2
  grid
end

def draw_rocks(str, example, part)
  grid = draw_grid(example, part)
  xmin = 0
  xmax = 9
  ymin = example ? 494 : 490
  ymax = example ? 503 : 559
  str.split("\n").each do |path|
    split_path = path.split(' -> ')
    split_path.each_with_index do |coords, i|
      next if i == 0
      prevy, prevx = split_path[i-1].split(',').map {|num| num.to_i }
      coory, coorx = coords.split(',').map {|num| num.to_i }
      prevy -= ymin
      coory -= ymin

      if prevx == coorx
        [prevy..coory].first.each do |y|
          grid[prevx][y] = '#'
        end
        [coory..prevy].first.each do |y|
          grid[prevx][y] = '#'
        end
      elsif prevy == coory
        [prevx..coorx].first.each do |x|
          grid[x][prevy] = '#'
        end
        [coorx..prevx].first.each do |x|
          grid[x][prevy] = '#'
        end
      end
    end
  end
  display_grid(grid)
  return grid
end

def pour_rocks(input, example, part)
  grid = draw_rocks(input, example, part)
  ymin = example ? 494 : 490
  sourcex = 0
  sourcey = 500 - ymin

  grid[sourcex][sourcey] = '+'
  i = 0
  if part == 1
    void = false
    while (!void)
      grid, void, _ = drop_sand(grid, sourcex, sourcey)
      i += 1
      display_grid(grid)
    end
    return (i - 1)
  elsif part == 2
    blocks_source = false
    while (!blocks_source)
      grid, _, blocks_source = drop_sand(grid, sourcex, sourcey)
      i += 1
    end
    display_grid(grid)
    return i
  end
end

def drop_sand(grid, sourcex, sourcey)
  sandx = sourcex
  sandy = sourcey
  moved = true
  blocks_source = false
  while (moved) do
    if grid[sandx+1][sandy] == '.'
      sandx += 1
    elsif grid[sandx+1][sandy-1] == '.'
      sandx += 1
      sandy -= 1
    elsif grid[sandx+1][sandy+1] == '.'
      sandx += 1
      sandy += 1
    else
      moved = false
    end
  end
  grid[sandx][sandy] = 'o'
  
  blocks_source = true if (sandx == sourcex && sandy == sourcey)

  return [grid, false, blocks_source]
rescue NoMethodError
  return [grid, true, blocks_source]
end

puts pour_rocks(sample, true, 1)
puts pour_rocks(input, false, 1)

puts '~~~~~'
#### Part 2

puts pour_rocks(sample, true, 2)
puts pour_rocks(input, false, 2)
