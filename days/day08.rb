require 'pry'

input_path = File.join(File.dirname(__FILE__), '../inputs/day08.txt')
input = File.read(input_path)

sample = <<-TEXT
30373
25512
65332
33549
35390
TEXT

def build_tree_grid(input)
  grid = []
  input.split("\n").each do |row|
    ln = []
    row.split('').each do |height|
      ln.push(height.to_i)
    end
    grid.push(ln)
  end

  return grid
end

DIRECTIONS = [[-1, 0], [0, -1], [1, 0], [0, 1]]

def visible_from_outside?(x, y, tree_height, grid)
  max_x = grid.length
  max_y = grid[0].length
  
  if (x == 0 || y == 0 || x == max_x - 1 || y == max_y - 1)
    return true
  end
  visible = false
  DIRECTIONS.each do |diff|
    i = 1
    diff_x, diff_y = diff.map { |x| x * i }
    a = diff_x + x
    b = diff_y + y
    dir_vis = true
    while (a >= 0 && b >= 0 && a < max_x && b < max_y && dir_vis)
      if grid[a][b] >= tree_height
        dir_vis = false
      end
      i += 1
      diff_x, diff_y = diff.map { |x| x * i }
      a = diff_x + x
      b = diff_y + y
    end
    visible = true if dir_vis
  end
  return visible
end

def sum_visibile_trees(input)
  sum = 0
  comps = 0 
  grid = build_tree_grid(input)

  grid.each_with_index do |row, i|
    row.each_with_index do |tree, j|
      if visible_from_outside?(i, j, tree, grid)
        sum += 1
      end
    end
  end
  return sum
end


puts sum_visibile_trees(sample)
puts "####"
puts sum_visibile_trees(input)


#### Part 2 


def view_distance(x,y,tree_height, grid)
  scores = []
  max_x = grid.length
  max_y = grid[0].length
  
  if (x == 0 || y == 0 || x == max_x - 1 || y == max_y - 1)
    return 0
  end

  DIRECTIONS.each do |diff|
    i = 1
    diff_x, diff_y = diff.map { |x| x * i }
    a = diff_x + x
    b = diff_y + y
    dir_vis = true
    while (a >= 0 && b >= 0 && a < max_x && b < max_y && dir_vis)
      if grid[a][b] >= tree_height
        dir_vis = false
        scores.push(i)
      end

      i += 1
      diff_x, diff_y = diff.map { |x| x * i }
      a = diff_x + x
      b = diff_y + y
    end
    scores.push(i - 1 ) if dir_vis
  end

  return scores.reduce(1) { |x, y| x * y }
end

def find_ideal_treehouse_spot(input)
  grid = build_tree_grid(input)
  high_score = 0
  grid.each_with_index do |row, i|
    row.each_with_index do |tree, j|
      score = view_distance(i,j,tree, grid)
      if score > high_score
        high_score = score
      end
    end 
  end
  return high_score
end

puts "~~~~~~"
puts find_ideal_treehouse_spot(sample)
puts "######"
puts find_ideal_treehouse_spot(input)