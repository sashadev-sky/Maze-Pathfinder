require 'colorize'

class Maze
  DELTAS = [[1, 1], [1, 0], [1, -1], [0, -1], [-1 , -1], [-1, 0], [-1, 1], [0, 1]].freeze.each(&:freeze)

  attr_reader :start_ind, :end_ind

  def initialize(filename)
    @map = load_map(filename)
    @title = parse_title(filename)
    @start_ind = find_start
    @end_ind = find_end
  end

  def load_map(filename)
    maze = []
    File.open("./mazes/#{filename}").each_line { |line| maze << line.split("") }
    maze
  end

  # Using reverse throughout the script so that the @map nested array matches a graph perspective
  # (arrays at the end will be printed on the bottom and should therefore have lower values)
  def is_wall?(point)
    x, y = point
    @map.reverse[y][x] == "*"
  end

  def in_maze?(point)
    x, y = point
    not_negative = (x >= 0) && (y >= 0)
    within_bounds = (x.between?(1, @map[0].length - 2)) && (y.between?(1, @map.length - 2))
    not_negative && within_bounds
  end

  def parse_title(filename)
    File.basename(filename, ".txt")
  end

  def to_s
    puts "Maze: #{@title}\n".bold
    string = ""
    @map.each { |line| string << line.join("") }
    string
  end

  def find_start
    find_char("S")
  end

  def find_end
    find_char("E")
  end

  def find_char(char)
    @map.reverse.each_with_index do |line, y|
      return [line.index(char), y] if line.index(char)
    end
  end

  # Moving clockwise, there are 8 adjacent squares:
  # upper right diag, direct right, lower right diag, direct below, lower left diag, direct left, upper left diag, direct up
  def find_neighbors(point)
    p_x, p_y = point
    neighbors = []
    DELTAS.each do |d_x, d_y|
      neighbor = [(d_x + p_x), (d_y + p_y)]
      if in_maze?(neighbor) && !(is_wall?(neighbor))
        neighbors << neighbor
      end
    end
    neighbors
  end

  def travel_path(path)
    puts "                  "
    puts "...thinking..."
    sleep(2)
    puts "                     "
    puts "Traveling path:".bold + " #{path.reverse.inspect}"
    puts "               "
    copy_map = deep_dup(@map)
    path.each do |coords|
      x, y = coords
      point = copy_map.reverse[y][x]
      case point
      when "X" then puts "This path back-tracks to #{x}, #{y}."
      when "*" then puts "This path hits a wall at #{x}, #{y}."
      when "S" then copy_map.reverse[y][x] = "S"
      when "E" then copy_map.reverse[y][x] = "E"
      else copy_map.reverse[y][x] = "X".colorize(:green)
      end
    end

    show_path(copy_map)
  end

  def show_path(map)
    # no reverse here, this is the final output
    map.each { |line| puts line.join("") }
    puts "                  "
  end

  private

  def deep_dup(item)
    unless item.class == Array
      item.dup
    else
      item.map { |el| deep_dup(el) }
    end
  end

end
