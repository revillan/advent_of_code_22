input_path = File.join(File.dirname(__FILE__), '../inputs/day01.txt')
input = File.read(input_path)

sample = <<-TEXT
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
TEXT

## updated to only reflect part 2
def max_calories(str)
  elf_pack = str.split("\n\n")
  elf_pack.map! do |snacks|
    snacks.split("\n").map { |num| num.to_i }.sum
  end

  elf_pack.max(3).sum
end

puts max_calories(sample)

puts max_calories(input)