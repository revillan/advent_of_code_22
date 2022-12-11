require 'pry'

input_path = File.join(File.dirname(__FILE__), '../inputs/day10.txt')
input = File.read(input_path)

sample = <<-TEXT
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
TEXT



def run_cycles(input)
  signals = []
  crt_screen = build_crt_screen
  x = 1
  cycle = 0
  input.split("\n").each do |line|
    instruction, value = line.split(' ')

    if instruction == 'noop'
      cycle += 1
      signals.concat(interesting_signal_strengths(cycle, x))
      draw_pixel(cycle, x, crt_screen)
      next
    end

    2.times do 
      cycle += 1
      signals.concat(interesting_signal_strengths(cycle, x))
      draw_pixel(cycle, x, crt_screen)
    end
    x += value.to_i
  end

  crt_screen.each { |row| puts row.join('') }
  return signals.reduce(0) { |a, b| a + b }
end

def interesting_signal_strengths(cycle, val)
  return [] unless (cycle - 20) % 40 == 0 || cycle == 20
  [cycle * val]
end

def build_crt_screen
  grid = []
  6.times do |i|
    grid.push(Array.new(40))
  end
  return grid
end

def draw_pixel(cycle, x, screen)
  cycle -= 1
  pos_x = cycle / 40
  pos_y = cycle % 40
  if ((x - pos_y).abs < 2)
    char = '#'
  else
    char = '.'
  end

  screen[pos_x][pos_y] = char
  return screen
end


puts run_cycles(sample)
puts "\n\n"
puts run_cycles(input)

