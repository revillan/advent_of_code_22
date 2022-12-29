require 'pry'

input_path = File.join(File.dirname(__FILE__), '../inputs/day21.txt')
input = File.read(input_path)

sample = <<-TEXT
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
TEXT

def compute_value(num1, num2, operator)
  case operator
  when "+"
    num1 + num2
  when "-"
    num1 - num2
  when "*"
    num1 * num2
  when "/"
    num1 / num2
  end
end

def compute_inverse(num1, num2, operator)
  case operator
  when "+"
    num1 - num2
  when "-"
    num1 + num2
  when "*"
    num1 = num1.to_f if num1 % num2 != 0
    num1 / num2
  when "/"
    num1 * num2
  end
end

def cycle_monkeys(input, test=nil, part=1)
  monkey_values = {}
  to_compute = []

  input.split("\n").each do |line|
    dir = line.split(' ')
    key = dir[0].slice(0,4)
    if key == 'humn' && part == 2
      monkey_values[key] = 'x'
      monkey_values[key] = test if test
    elsif dir.length == 2
      monkey_values[key] = dir[1].to_i
    else
      eqn = dir.slice(1, dir.length)
      to_compute.push([key, eqn])
    end
  end

  while (monkey_values['root'] == nil) do
    next_to_compute = []
    to_compute.each do |monkey_job|
      monkey, job = monkey_job
      input1 = job[0]
      input2 = job[2]
      if monkey_values[input1] && monkey_values[input2]
        num1 = monkey_values[input1]
        num2 = monkey_values[input2]
        if monkey == 'root'
          correct_num = find_correct_number(num1, num2) if !test
          monkey_values[monkey] = (num1 == num2)
        else
          if num1.is_a?(String) || num2.is_a?(String)
            monkey_values[monkey] = "( #{num1} #{job[1]} #{num2} )"
          else
            monkey_values[monkey] = compute_value(num1, num2, job[1])
          end
        end
      else
        next_to_compute.push(monkey_job)
      end
    end
    to_compute = next_to_compute
  end
  return monkey_values['root']
end

## This did not work, b/c of uneven divisions
## Used a binary search instead
def find_correct_number(num1, num2)
  rhs = num1.is_a?(Integer) ? num1 : num2
  lhs = num1.is_a?(String) ? num1 : num2
  arr = lhs.split(' ')
  # binding.pry
  l = 0
  r = arr.length - 1
  while (l < r) do
    if (arr[l] == arr[l+1]) # right next
      num = arr[r-1].to_i
      op = arr[r-2]
      r -= 2
    elsif (arr[r] == arr[r-1]) # left next
      num = arr[l+1].to_i
      op = arr[l+2]
      l += 2
    else
      l += 1
      r -= 1

      num = arr[r].to_i if arr[l] == 'x'
      num = arr[l].to_i if arr[r] == 'x'
      op = arr[l+1]
    end
    r -= 1
    l += 1
    # p [rhs, num, op]
    # p arr.slice(l..r).join(' ')
    rhs = compute_inverse(rhs, num, op)

  end
  return rhs
end


## Part 1
puts cycle_monkeys(sample)
puts cycle_monkeys(input)


def bin_search(l,r, input)
  return ";(" if l >= r
  return [l,r] if (l - r).abs < 3
  mid = (l + r) / 2
  if cycle_monkeys(input, mid) > 0
    l = mid
  else
    r = mid
  end
  
  return bin_search(l, r, input)
end

## Part 2
puts bin_search(0, 9443921358293, input)
puts cycle_monkeys(sample, 301)
puts cycle_monkeys(input, 3343167719435)
# puts cycle_monkeys(input, -9443921358293 * 2 - 100000000000)
