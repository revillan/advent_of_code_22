require 'pry'
input_path = File.join(File.dirname(__FILE__), '../inputs/day03.txt')
input = File.read(input_path)

sample = <<-TEXT
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
TEXT

def find_priority(letter)
  priority = 0
  priority += 26 if letter == letter.upcase
  priority += letter.upcase.ord - 64
  priority
end

def find_common_item(front, back)
  hash = {}
  front.each do |char|
    hash[char] = true
  end
  common_items = []
  back.each do |char|
    common_items.push(char) if hash[char]
  end
  return common_items.first
end

def process_rucksack_priorities(list)
  rucksacks = list.split("\n")
  sum = 0
  rucksacks.each do |rucksack|
    array = rucksack.split('')
    length = array.length
    front = array.slice(0, length / 2)
    back = array.slice(length / 2 , length / 2)
    common_item = find_common_item(front, back)
    sum += find_priority(common_item)
  end
  return sum
end

# puts process_rucksack_priorities(sample)
# puts "\n#######\n"
# puts process_rucksack_priorities(input)


### Part 2

def find_common_in_three(a,b,c)
  hash1 = {}
  a.split('').each do |char|
    hash1[char] = true
  end
  hash2 = {}
  b.split('').each do |char|
    hash2[char] = true if hash1[char]
  end
  common_items = []
  c.split('').each do |char|
    common_items.push(char) if hash2[char]
  end
  return common_items.first
end

def process_groups_of_three(list)
  sum = 0
  list.split("\n").each_slice(3) do |a,b,c|
    common_item = find_common_in_three(a,b,c)
    sum += find_priority(common_item)
  end
  return sum
end

puts process_groups_of_three(sample)
puts "\n#######\n"
puts process_groups_of_three(input)