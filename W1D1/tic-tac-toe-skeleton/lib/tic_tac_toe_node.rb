require_relative "tic_tac_toe"
require "byebug"

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos
  attr_writer :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if self.board.over?
      return false if self.board.winner == evaluator || self.board.winner == nil
      return true
    else
      if evaluator == self.next_mover_mark
        return true if self.children.all? { |child| child.losing_node?(evaluator) }
      else
        return true if self.children.any? { |child| child.losing_node?(evaluator) }
      end
    end
    false
  end

  def winning_node?(evaluator)
    if self.board.over?
      return true if self.board.winner == evaluator
    else
      if evaluator == self.next_mover_mark
        return true if self.children.any? { |child| child.winning_node?(evaluator) }
      else
        return true if self.children.all? { |child| child.winning_node?(evaluator) }
      end
    end
    false
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    moves = []
    (0..2).each do |row|
      (0..2).each do |col|
        if self.board.empty?([row, col])
          next_move_node = TicTacToeNode.new(self.board.dup, self.next_mover_mark, [row, col])
          next_move_node.board[[row, col]] = self.next_mover_mark
          next_move_node.swap_next_mover
          moves << next_move_node
        end
      end
    end
    moves
  end

  def swap_next_mover
    if self.next_mover_mark == :x
      self.next_mover_mark = :o
    else
      self.next_mover_mark = :x
    end
  end
end
