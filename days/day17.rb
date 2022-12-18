require 'pry'
require 'set'

input_path = File.join(File.dirname(__FILE__), '../inputs/day17.txt')
input = File.read(input_path)

sample = <<-TEXT
>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
TEXT


class Tetris
  def initialize(input)
    @jet_pattern = input.strip.split('')
    @jet_index = 0
    @shape_index = 0
    @chamber = build_initial_chamber
    @height = 0
  end

  def next_push
    ind = @jet_index % @jet_pattern.length
    dir = @jet_pattern[ind]
    @jet_index += 1
    return dir
  end

  def build_initial_chamber
    grid = []
    3.times do 
      row = []
      7.times do
        row.push('.')
      end
      grid.push(row)
    end
    return grid
  end

  def three_rows(shape)
    ((@height + SHAPES[shape][:height] + 3) - @chamber.length).times do
      row = []
      7.times do
        row.push('.')
      end
      @chamber.push(row)
    end
  end

  SHAPES = {
    flat: {
      height: 1,
      wight: 4,
      coords: [[2, 0], [3, 0], [4, 0], [5, 0]]
    },
    plus: {
      height: 3,
      width: 3,
      coords: [[3, 0], [2, 1], [3, 1], [4, 1], [3, 2]]
    },
    el: {
      width: 3,
      height: 3,
      coords: [[4, 0], [4, 1], [2, 0], [3, 0], [4, 2]]
    },
    tall: {
      height: 4,
      width: 1,
      coords: [[2, 0], [2, 1], [2, 2], [2, 3]]
    },
    square: {
      width: 2,
      height: 2,
      coords: [[2, 0], [3, 0], [2, 1], [3, 1]]
    }
  }

  DIFFS = {
    ">" => [1, 0],
    "<" => [-1, 0]
  }

  def display
    (@chamber.size - 1).downto(0) do |i|
      row = @chamber[i]
      puts row.join('')
    end
    puts ''
  end

  def update_height(coords)
    max_y = coords.map {|(_, y)| y }.max + 1
    @height = max_y if max_y > @height
  end

  def drop_many_shapes
    shapes = [:flat, :plus, :el, :tall, :square]
    n_shapes = []
    heights = []
    3610.times do |i|
      shape = shapes[i % 5]
      drop_shape(shape)
      
      if @jet_index % @jet_pattern.length == 2
        n_shapes.push(i)
        heights.push(@height)
      end
    end
    p "HEIGHTS"
    out = heights.map.with_index do |h, i|
      if i == 0
        0
      else 
        h - heights[i - 1]
      end
    end
    p out
    p "~"
    p "SHAPES # "
    out = n_shapes.map.with_index do |h, i|
      if i == 0
        0
      else 
        h - n_shapes[i - 1]
      end
    end
    p out
    puts  " Jet pattern Length #{@jet_pattern.length}"
    return @height
  end

  def drop_shape(shape)
    coords = SHAPES[shape][:coords]
    coords = coords.map { |(x, y)| [x, y + (@height + 3)]}
    
    three_rows(shape)

    # i = 0
    while(coords.none? { |(x, y)| y < 0 || @chamber[y][x] == '#' }) do
      prev_coords = coords.clone

      # push
      diff = DIFFS[next_push]
      coords = coords.map { |(x,y)| [x + diff[0], y + diff[1]] }
      coords = prev_coords if coords.any? { |(x,y)| x < 0 || x > 6 || @chamber[y][x] == '#' }

      # fall
      prev_coords = coords.clone
      coords = coords.map { |(x,y)| [x , y - 1] }
    end

    prev_coords.each do |(x,y)|
      @chamber[y][x] = '#'
    end
    update_height(prev_coords)
  end
end

samp = Tetris.new(sample)
puts samp.drop_many_shapes

puzzle = Tetris.new(input)
puts puzzle.drop_many_shapes
# 576368876 × 1735 + 140 shapes
# 2711 * 576368876 + (height of 140 shapes)

