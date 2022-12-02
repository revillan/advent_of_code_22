test_input = <<-SAMPLE
A Y
B X
C Z
SAMPLE

input_path = File.join(File.dirname(__FILE__), '../inputs/day02.txt')
input = File.read(input_path)

WIN_SCORE = {
  A: {
    X: 3,
    Y: 6,
    Z: 0
  },
  B: {
    X: 0,
    Y: 3,
    Z: 6
  },
  C: {
    X: 6,
    Y: 0,
    Z: 3
  }
}

# (1 for Rock, 2 for Paper, and 3 for Scissors)
PLAY_SCORE = {
  X: 1,
  Y: 2,
  Z: 3
}

def calculate_score(input)
  score = 0
  rounds = input.split("\n")
  rounds.each do |round|
    opponent, us = round.split(" ").map { |char| char.to_sym }
    score += (WIN_SCORE[opponent][us] + PLAY_SCORE[us])
  end
  return score
end

puts calculate_score(test_input)
puts calculate_score(input)

### Part Two

WIN_SCORE_PART_2 = {
  X: 0,
  Y: 3,
  Z: 6
}

PLAY_SCORE_PART_2 = {
  A: {
    X: 3,
    Y: 1,
    Z: 2
  },
  B: {
    X: 1,
    Y: 2,
    Z: 3
  },
  C: {
    X: 2,
    Y: 3,
    Z: 1
  }
}

def calculate_score_part_2(input)
  score = 0
  rounds = input.split("\n")
  rounds.each do |round|
    opponent, us = round.split(" ").map { |char| char.to_sym }
    score += (WIN_SCORE_PART_2[us] + PLAY_SCORE_PART_2[opponent][us])
  end
  return score
end

puts calculate_score_part_2(test_input)
puts calculate_score_part_2(input)
