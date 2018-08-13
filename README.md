# Maze Solver

- An implementation of the A* shortest path algorithm for solving parsed mazes, written in Ruby for the terminal console.

## Overview
- Run the command `bundle install` in your terminal
- To run the pathfinder: `ruby lib/maze_solver.rb`
- I have provided 3 test mazes in the `mazes` directory
  - The current setting is to run the pathfinder on the first maze. If you would like to try running the others, change the input filename on line 132 of the `lib/maze_solver.rb` file and save your changes, then run the `ruby lib/maze_solver.rb` command again.

## Implementation Notes
- Two files in the `lib` directory hold the code:
  - `maze.rb` loads in the maze.txt file and parses it. It holds all of the information on the maze itself
  - `maze_solver.rb` holds all of the logic for the A* algorithm
- Find specific comments on my implementation of the A* algorithm in my code, as well as other useful notes
- Possible outputs from testing:
  - 1) If the path is blocked with not even an initial move available, "This maze has no available moves" will print to the terminal screen.
  - 2) If there are moves but the maze is found to be unsolvable, the traveling path that got the closest to the end will print to the terminal screen.
  - 3) Otherwise you will always get the fastest path according to the A* algorithm
- Note that all of the mazes I provided are solvable

#### Ruby Concepts (personal use)
- `colorize` gem
- Reversing a grid to have graph perspective
- `File` class I/O
- Computer pathfinding
- Overriding `to_s`
- `send` method
- `hash` deep dup
