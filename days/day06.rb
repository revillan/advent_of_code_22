require 'pry'

input_path = File.join(File.dirname(__FILE__), '../inputs/day06.txt')
input = File.read(input_path)

example1 = 'mjqjpqmgbljsphdztnvjfqwrcgsmlb'
example2 = 'bvwbjplbgvbhsrlpgdmjqwftvncz'
example3 = 'nppdvjthqldpwncqszvftbrmjlhg'
example4 = 'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg'
example5 = 'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'


def characters_to_process_signal(str, spaces_to_wait)
  char_array = str.split('')
  tracker = {}
  first = 0
  last = 0
  while last < spaces_to_wait
    char = char_array[last]
    tracker[char] ||= 0
    tracker[char] += 1
    last += 1
  end
  while tracker.keys.count < spaces_to_wait
    # remove value no longer in window
    char_removed = char_array[first]
    if tracker[char_removed] > 1
      tracker[char_removed] -= 1
    else
      tracker.delete(char_removed)
    end
    
    # add new value in window
    char_to_add = char_array[last]
    tracker[char_to_add] ||= 0
    tracker[char_to_add] += 1
    
    first += 1
    last += 1
  end

  return last
end

puts characters_to_process_signal(example1, 4)
puts characters_to_process_signal(example2, 4)
puts characters_to_process_signal(example3, 4)
puts characters_to_process_signal(example4, 4)
puts characters_to_process_signal(example5, 4)

puts "####"
puts characters_to_process_signal(input, 4)

#### Part 2 

puts "~~~~~~~~~~~~~"

puts characters_to_process_signal(example1, 14)
puts characters_to_process_signal(example2, 14)
puts characters_to_process_signal(example3, 14)
puts characters_to_process_signal(example4, 14)
puts characters_to_process_signal(example5, 14)

puts "####"
puts characters_to_process_signal(input, 14)