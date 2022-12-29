require 'pry'

input_path = File.join(File.dirname(__FILE__), '../inputs/day25.txt')
input = File.read(input_path)

sample = <<-TEXT
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
TEXT

def snafu_to_decimal(snafu)
  sum = 0
  last_index = snafu.length - 1
  (last_index).downto(0) do |i|
    place = 5 ** (last_index - i)
    digit = snafu[i]
    next if digit == '0'
    if ['1', '2'].include?(digit)
      sum += (place * digit.to_i)
    else
      negative_digit = (digit == '-' ? -1 : -2)
      sum += (place * negative_digit)
    end
  end
  return sum
end

MAP = {
  2 => '2',
  1 => '1',
  0 => '0',
  -1 => '-',
  -2 => '='
}

def decimal_to_snafu(decimal)
  max_place = 0
  decimal_sum = decimal
  while (5 ** max_place) < decimal
    max_place += 1
  end
  snafu = []
  max_place.downto(0) do |i|
    place = 5 ** i
    diff = Float::INFINITY
    digit = nil
    (-2).upto(2) do |j|
      if (decimal - place * j).abs < diff
        diff = (decimal - place * j).abs
        digit = j
      end
    end
    snafu.push(MAP[digit])
    decimal -= ( place * digit)
  end
  return snafu.join
end

def snorf_snafu(input)
  decimal_sum = 0
  input.split("\n").each do |num|
    num_arr = num.split('')
    decimal_sum += snafu_to_decimal(num_arr)
  end
  puts decimal_sum
  return decimal_to_snafu(decimal_sum)
end

puts snorf_snafu(sample)
puts snorf_snafu(input)

