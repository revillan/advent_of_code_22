require 'pry'

sample = <<-SAMPLE
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
SAMPLE

input_path = File.join(File.dirname(__FILE__), '../inputs/day05.txt')
input = File.read(input_path)

def create_stacks(input)
  lines = input.split("\n")
  stacks = {}
  lines.pop.split("   ").each do |num|
    stacks[num.to_i] = []
  end

  lines.each do |row|
    row.split('').each_slice(4).with_index do |char, i|
      stack = i + 1 
      value = char.select { |val| !(['[', ']', ' '].include?(val)) }.first
      stacks[stack].unshift(value) if value
    end
  end
  stacks
end

def move_one(from, to, stacks)
  val = stacks[from].pop
  stacks[to].push(val)
end

def move_multiple(from, to, number_times, stacks)
  number_times.times do 
    move_one(from, to, stacks)
  end
end

def top_of_stacks(stacks)
  tops = []
  1.upto(stacks.keys.length) do |i|
    tops.push(stacks[i].last)
  end
  tops.join('')
end

def final_stack_tops(input)
  initial_stack, instructions = input.split("\n\n")
  stacks = create_stacks(initial_stack)

  instructions.split("\n").each do |instruction|
    split_instructions = instruction.split(' ')
    number_times = split_instructions[1].to_i
    from = split_instructions[3].to_i
    to = split_instructions[5].to_i
    move_multiple(from, to, number_times, stacks)
  end

  return top_of_stacks(stacks)
end

puts final_stack_tops(sample)
puts "#########"
puts final_stack_tops(input)


####### Part 2 

def move_multiple_simulateously(from, to, number_crates, stacks)
  from_stack = stacks[from]
  crate_array = from_stack.slice!(from_stack.length - number_crates, from_stack.length)

  stacks[to] = stacks[to].concat(crate_array)
end

def final_stack_tops_part_2(input)
  initial_stack, instructions = input.split("\n\n")
  stacks = create_stacks(initial_stack)

  instructions.split("\n").each do |instruction|
    split_instructions = instruction.split(' ')
    number_times = split_instructions[1].to_i
    from = split_instructions[3].to_i
    to = split_instructions[5].to_i
    move_multiple_simulateously(from, to, number_times, stacks)
  end

  return top_of_stacks(stacks)
end

puts final_stack_tops_part_2(sample)
puts "#########"
puts final_stack_tops_part_2(input)

