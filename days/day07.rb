require 'pry'

sample = <<-TEXT
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
TEXT

input_path = File.join(File.dirname(__FILE__), '../inputs/day07.txt')
input = File.read(input_path)

def add_to_directory(directory, path, ls_line)
  cur = directory
  path.each do |namespace|
    cur = cur[namespace]
  end

  if ls_line[0] == 'dir'
    cur[ls_line[1]] ||= {}
  else

    cur[ls_line[1]] = ls_line[0].to_i
  end
end


def build_file_object(input)
  directory = {'/' => {}}
  path = []
  lines = input.split("\n")
  i = 0

  while (i < lines.length) do
    line = lines[i].split(' ')

      if (line[1] == 'cd' && line[2] == '..')
        path.pop
      elsif (line[1] == 'cd' && line[2] == '/')
        path = ['/']
      elsif (line[1] == 'cd')
        path.push(line[2])
        # binding.pry
      elsif (line[1] == 'ls')
        i += 1
        while (lines[i] && lines[i][0] != "$")
          ls_line = lines[i].split(' ')
          add_to_directory(directory, path, ls_line)
          i += 1
        end
        i -= 1
      end
    i += 1
  end

  find_sizes(directory)
  return directory
end

def find_sizes(directory)
  current_sum = 0
  to_examine = []
  directory.each do |key, val|
    if val.is_a?(Integer)
      current_sum += val
    elsif val.has_key?('size')
      current_sum += val['size']
    else
      to_examine.push(key)
    end
  end

  to_examine.each do |key|
    dir = directory[key]
    size = find_sizes(dir)
    dir['size'] = size
    current_sum += size
  end

  return current_sum
end

def find_dirs_over(directory, size)
  sum = 0
  directory.each do |key, val|
    if val.is_a?(Hash)
      sum += val['size'] if val['size'] < size
      sum += find_dirs_over(val, size)
    end
  end
  return sum
end

def sum_dirs_less_than(input)
  dir = build_file_object(input)
  find_dirs_over(dir, 100000)
end

p sum_dirs_less_than(sample)
puts "######"
p sum_dirs_less_than(input)


##### Part 2

def directory_to_delete(input)
  dir = build_file_object(input)
  dir = dir['/']

  unused_space = 70000000 - dir['size']
  space_to_free = 30000000 - unused_space
  
  dir_to_delete_size = 30000000
  dir_to_delete = nil

  return recursive_search(dir, dir_to_delete_size, dir_to_delete, space_to_free)
end


def recursive_search(dir, dir_to_delete_size, dir_to_delete, space_to_free)
  dir.each do |key, val|  
    if val.is_a?(Hash)

      if val['size'] > space_to_free && val['size'] < dir_to_delete_size
        dir_to_delete = key
        dir_to_delete_size = val['size']
      end

      recurse = recursive_search(val, dir_to_delete_size, dir_to_delete, space_to_free)
      if recurse[1] && recurse[1] < dir_to_delete_size
        dir_to_delete_size = recurse[1]
        dir_to_delete = recurse[0]
      end
    end
  end

  return [dir_to_delete, dir_to_delete_size]
end


puts " ~~~~~~ "
p directory_to_delete(sample)
puts "#####"
p directory_to_delete(input)
