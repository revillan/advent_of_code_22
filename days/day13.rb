require 'pry'

input_path = File.join(File.dirname(__FILE__), '../inputs/day13.txt')
input = File.read(input_path)

sample = <<-TEXT
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
TEXT

class Array
  def deep_lookup(arr)
    out = self
    arr.each do |ind|
      out = out[ind]
    end
    out
  end
end

def right_order_pairs(str)
  pairs = str.split("\n\n")
  right_order_indices = []

  pairs.each_with_index do |pair, i|
    a, b = pair.split("\n").map { |list| eval(list) }

    right_order_indices.push(i + 1) if sort_two(a, b) == -1
  end
  p right_order_indices
  return right_order_indices.sum
end

def sort_two(a, b)
  path = [0]

  asub = a
  bsub = b
  path.each do |ind|
    asub = asub[ind]
    bsub = bsub[ind]
  end
  unless asub.class == bsub.class
    cloned_path = path.clone
    cloned_path.pop
    if asub.is_a?(Integer)
      a.deep_lookup(cloned_path)[path.last] = [a.deep_lookup(path)]
    end
    if bsub.is_a?(Integer)
      b.deep_lookup(cloned_path)[path.last] = [b.deep_lookup(path)]
    end
  end
  current_result = compare_two(asub, bsub)
  while ([0, nil].include?(current_result)) do
    if asub.nil? && bsub.nil?
      path.pop
      path[path.length - 1] = path[path.length - 1] + 1
    elsif current_result == 0
      if asub.is_a?(Array) && bsub.is_a?(Array)
        path.push(0)
      else
        path[path.length - 1] = path[path.length - 1] + 1
      end
    elsif current_result == nil
      unless asub.class == bsub.class
        cloned_path = path.clone
        cloned_path.pop
        if asub.is_a?(Integer)
          a.deep_lookup(cloned_path)[path.last] = [a.deep_lookup(path)]
        end
        if bsub.is_a?(Integer)
          b.deep_lookup(cloned_path)[path.last] = [b.deep_lookup(path)]
        end
      end
      path.push(0)
    end
    asub = a
    bsub = b
    path.each do |ind|
      asub = asub[ind]
      bsub = bsub[ind]
    end
    current_result = compare_two(asub, bsub)
  end
  current_result
end

def compare_two(a, b)
  if a.is_a?(Integer) && b.is_a?(Integer)
    a <=> b
  elsif a.is_a?(Array) && b.is_a?(Array)
    i = 0
    amem = a[i]
    bmem = b[i]
    diff = (amem <=> bmem)
    while (amem.is_a?(Integer) && bmem.is_a?(Integer) && diff == 0) do
      i += 1
      amem = a[i]
      bmem = b[i]
      diff = (amem <=> bmem)
      #both arrays run out (identical)
      return 0 if amem.nil? && bmem.nil?
      # member no longer Array
      return nil unless amem.is_a?(Integer) && bmem.is_a?(Integer)
    end

    return -1 if amem.nil? && bmem.is_a?(Integer)
    return 1 if bmem.nil? && amem.is_a?(Integer)
    return diff
  elsif a.nil? && b.nil?
    nil
  elsif a.nil?
    -1
  elsif b.nil?
    1
  else
    nil
  end
end

def sort_all_packets(input)
  divider1 = [[2]]
  divider2 = [[6]]

  packets = input.gsub("\n\n", "\n").split("\n").map { |pack| eval(pack) }
  packets.push(divider1, divider2)
  sorted_packets = packets.sort { |a,b| sort_two(a,b) }

  index1 = sorted_packets.index(divider1) + 1
  index2 = sorted_packets.index(divider2) + 1
  return index1 * index2
end

## Part 1
puts right_order_pairs(sample)
puts right_order_pairs(input)

## Part 2
puts sort_all_packets(sample)
puts sort_all_packets(input)
