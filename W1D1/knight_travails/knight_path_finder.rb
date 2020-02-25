require_relative "poly_tree_node.rb"
require "byebug"

class KnightPathFinder
  attr_reader :root_node, :considered_positions, :move_tree

  def initialize(coordinate)
    @root_node = PolyTreeNode.new(coordinate)
    @considered_positions = [coordinate]
    @move_tree = self.build_move_tree
  end

  #---------------Class Methods

  def self.valid_moves(pos)
    x, y = pos[0], pos[1]
    moves = [[x + 1, y + 2], [x + 2, y + 1], [x + 2, y - 1], [x + 1, y - 2],
             [x - 1, y - 2], [x - 2, y - 1], [x - 2, y + 1], [x - 1, y + 2]]
    moves.select { |move| move[0] >= 0 && move[0] < 8 && move[1] >= 0 && move[1] < 8 }
  end

  def new_move_positions(pos)
    moves = KnightPathFinder.valid_moves(pos)
    #debugger
    filtered_moves = moves.select { |move| !self.considered_positions.include?(move) }
    filtered_moves.each { |move| self.considered_positions << move }
    filtered_moves
  end

  def build_move_tree
    queue = [self.root_node]
    moves = []
    while !queue.empty?
      a = queue.shift
      new_moves = self.new_move_positions(a.value)
      new_moves.each do |move|
        new_node = PolyTreeNode.new(move)
        queue << new_node
        a.add_child(new_node)
        moves << new_node
      end
    end
    moves
  end

  def find_path(end_pos)
    end_node = self.root_node.bfs(end_pos)
    path_back = self.trace_path_back(end_node)
    p path_back
  end

  def trace_path_back(end_node)
    path = []
    path << end_node.value
    if end_node.parent != nil
      path += trace_path_back(end_node.parent)
    end

    path.rotate(1)
  end
end

kpf = KnightPathFinder.new([0, 0])
kpf.find_path([6, 2])
kpf.find_path([7, 6])
