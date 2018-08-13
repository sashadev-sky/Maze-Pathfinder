require_relative 'maze'

class Maze_Solver
  def initialize(maze)
    @maze = maze
    reset_values
  end

  def diagonal_move?(parent, neighbor)
    p_x, p_y = parent
    n_x, n_y = neighbor
    #if both their x coordinate and y coordinate changed, its a diagonal move
    p_x != n_x && p_y != n_y
  end

  # G: calculate movement cost to move from the original starting point to the queued square by following the path
  # generated to get there. Note that diagonal moves have a cost of 14 and horizantal/vertical have a cost of 10
  def calculate_g(neighbor)
    total_g = 0
    branching_dup = dup_hash(@branching_paths)
    loop do
      parent = branching_dup[neighbor]
      if diagonal_move?(parent, neighbor)
        total_g += 14
      else
        total_g += 10
      end
      break if neighbor == @maze.find_start
      neighbor = parent
    end
    total_g
  end

    # The Manhattan Method is a heuristic commonly used for calculating h: total # of squares moved horizantally and vertically
    # to reach the end from the queued square, ignoring any obstacles or diagonal movements.
    # Then estimate movement cost: total moves * 10
  def calculate_h(neighbor)
    n_x, n_y = neighbor
    final_x, final_y = @maze.find_end
    total_moves = ((n_x - final_x).abs + (n_y - final_y).abs)
    total_moves * 10
  end

  # Using this heuristic, we calculate the square with the lowest f score according to the formula F = G + H.
  # This is the square the path will move to next
  def manhattan_heuristic(open_squares)
    smallest_f = nil
    smallest_f_point = nil
    open_squares.each do |neighbor|
      g_score = calculate_g(neighbor)
      h_score = calculate_h(neighbor)
      f_score = h_score + g_score
      if smallest_f.nil? || f_score < smallest_f
        smallest_f = f_score
        smallest_f_point = neighbor
      end
    end
    smallest_f_point
  end

  def build_branching_paths(heuristic = :manhattan_heuristic)
    reset_values
    open_squares = [@current]
    closed = []

    if @maze.find_neighbors(@current) == []
      puts "                         "
      puts "This maze has no available moves"
      puts "                      "
      abort
    end
    until open_squares.empty? || (@current == @maze.find_end && closed.include?(@maze.find_end))
      #find_neighbors checks for obstacle squares for us via is_wall
      adjacent_squares = @maze.find_neighbors(@current)

      adjacent_squares.each do |neighbor|
        unless closed.include?(neighbor) || open_squares.include?(neighbor)
          open_squares << neighbor
          @branching_paths[neighbor] = @current
        end
      end
      open_squares.delete(@current)
      closed << @current

      @current = self.send(heuristic, open_squares)

      @branching_paths
    end
  end

  #starting from end to beginning
  def find_path(goal = @maze.find_end)
    path = [goal]
    spot = goal
    until @branching_paths[spot] == nil
      path << @branching_paths[spot]
      spot = @branching_paths[spot]
    end
    path
  end

  def solve(heuristic = :manhattan_heuristic)
    build_branching_paths(heuristic)
    path = find_path
    @maze.travel_path(path)
  end

  private

  def reset_values
    @branching_paths = {}
    @current = @maze.find_start
  end

  def dup_hash(branches)
    new_hash = {}
    branches.each do |k, v|
      new_k = k.dup
      new_v = v.dup
      new_hash[new_k] = new_v
    end
    new_hash
  end

end

#tests
if __FILE__ == $PROGRAM_NAME
  filename = ARGV[0] || "maze1.txt"
  test_maze = Maze.new(filename)
  puts "               "
  puts test_maze
  puts "Start is at #{test_maze.start_ind}"
  puts "End is at #{test_maze.end_ind}"
  test_solver = Maze_Solver.new(test_maze)
  test_solver.solve
end
