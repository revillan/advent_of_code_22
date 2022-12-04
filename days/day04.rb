input_path = File.join(File.dirname(__FILE__), '../inputs/day04.txt')
input = File.read(input_path)

sample = <<-TEXT
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
TEXT

def find_low_and_high(range)
  range.split('-').map { |num| num.to_i }
end

def fully_contained_count(pairs)
  fully_contained_count = 0
  pairs.split("\n").each do |pair|
    first, second = pair.split(',')
    first_start, first_end = find_low_and_high(first)
    second_start, second_end = find_low_and_high(second)
    if (first_start <= second_start && second_end <= first_end)
      fully_contained_count += 1
      # p [first, second]
    elsif ( second_start <= first_start && first_end <= second_end)
      fully_contained_count += 1
      # p [first, second]
    end
  end
  return fully_contained_count
end

puts fully_contained_count(sample)
puts "#######"
puts fully_contained_count(input)

##### Part 2

def any_overlap_count(pairs)
  fully_contained_count = 0
  pairs.split("\n").each do |pair|
    first, second = pair.split(',')
    first_start, first_end = find_low_and_high(first)
    second_start, second_end = find_low_and_high(second)

    if first_start > second_start 
      first_start, second_start = second_start, first_start
      first_end, second_end = second_end, first_end
    end

    if first_end >= second_start
      fully_contained_count += 1
    end
  end

  return fully_contained_count
end

puts any_overlap_count(sample)
puts "#######"
puts any_overlap_count(input)
