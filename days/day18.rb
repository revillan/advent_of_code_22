require 'pry'
require 'set'

input_path = File.join(File.dirname(__FILE__), '../inputs/day18.txt')
input = File.read(input_path)

tiny = <<-TEXT
1,1,1
2,1,1
TEXT

sample = <<-TEXT
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
TEXT


class Cubes

  def initialize
    @xy = {}
    @yz = {}
    @xz = {}
  end

  DIFFS = [[1,0,0], [-1,0,0], [0,1,0], [0,-1,0], [0,0,1], [0,0,-1]]

  def bfs_to_surface(list, max)
    reachable = Set.new
    list = list.map { |x,y,z| [x+1, y+1, z+1] }

    explored = {}
    queue = []
    start = [0,0,0]
    explored[start] = true
    queue.push(start)
    while (queue.length > 0) do
      current = queue.shift
      x,y,z = current
      DIFFS.each do |(i,j,k)|
        next_cube = [x+i, j+y, z+k]

        next if next_cube.any? { |dim| dim < 0 || dim > max }
        next if explored[next_cube]
        if list.include?(next_cube)
          key = next_cube.concat([i,j,k])
          reachable.add(key)
          next
        end
        explored[next_cube] = true
        queue.push(next_cube)
      end
    end

    return reachable.size
  end

  def surface_area(list)
    minus = 0
    list.each do |line|
      x, y, z = line

      xy = [x,y]
      yz = [y,z]
      xz = [x,z]
      @xy[xy] ||= []
      if @xy[xy].length > 0
        if (@xy[xy].include?(z - 1) && @xy[xy].include?(z + 1))
          minus += 4
        elsif @xy[xy].include?(z - 1) || @xy[xy].include?(z + 1)
          minus += 2
        end
      end
      @xy[xy].push(z)

      @yz[yz] ||= []
      if @yz[yz].length > 0
        if (@yz[yz].include?(x - 1) && @yz[yz].include?(x + 1))
          minus += 4
        elsif @yz[yz].include?(x - 1) || @yz[yz].include?(x + 1)
          minus += 2
        end
      end
      @yz[yz].push(x)

      @xz[xz] ||= []
      if @xz[xz].length > 0
        if (@xz[xz].include?(y - 1) && @xz[xz].include?(y + 1))
          minus += 4
        elsif @xz[xz].include?(y - 1) || @xz[xz].include?(y + 1)
          minus += 2
        end
      end
      @xz[xz].push(y)
    end
    return (6 * list.length) - minus
  end

  def consume_cubes(input, max=100)
    cube_list = input.split("\n").map { |line| line.split(',').map(&:to_i) }
    area = surface_area(cube_list)

    reachable_area = bfs_to_surface(cube_list, max)

    return [area, reachable_area]
  end
end

tiny_inst = Cubes.new
puts tiny_inst.consume_cubes(tiny)

samp_inst = Cubes.new
puts samp_inst.consume_cubes(sample,10)

puts "SPOOKY"
puzzle_inst = Cubes.new
puts puzzle_inst.consume_cubes(input, 25)