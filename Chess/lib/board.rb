require_relative "piece.rb"

class Board
  attr_reader :rows

  def initialize
    @rows = Array.new(8) { Array.new(8) }
    8.times do |i|
      rows[0][i] = Piece.new("Holder-color", "Holder-board", [0, i])
      rows[1][i] = Piece.new("Holder-color", "Holder-board", [1, i])
      rows[6][i] = Piece.new("Holder-color", "Holder-board", [6, i])
      rows[7][i] = Piece.new("Holder-color", "Holder-board", [7, i])
    end
    # @sentinel = NullPiece.new
  end

  def [](pos)
    row, col = pos[0], pos[1]
    return self.rows[row][col] if (0..8).include?(row) && (0..8).include?(col)
  end

  def []=(pos, val)
    row, col = pos[0], pos[1]
    self.rows[pos] = val if (0..8).include?(row) && (0..8).include?(col)
  end

  def move_piece(start_pos, end_pos)
    srow, scol = start_pos[0], start_pos[1]
    erow, ecol = end_pos[0], end_pos[1]
    raise NoPieceError if self.rows[srow][scol].class == NilClass
    raise InvalidEndPos if erow > 7 || erow < 0 || ecol > 7 || ecol < 0
    self.rows[srow][scol], self.rows[erow][ecol] = self.rows[erow][ecol], self.rows[srow][scol]
  end

  def move_piece!(color, start_pos, end_pos)
  end

  def valid_pos?(pos)
  end

  def add_piece(piece, pos)
  end

  def checkmate?(color)
  end

  def in_check?(color)
  end

  def find_king(color)
  end

  def pieces
  end

  def dup
  end
end

class NoPieceError < StandardError
end

class InvalidEndPos < StandardError
end

b = Board.new

p b.rows

b.move_piece([1, 0], [2, 0])
puts
p b.rows
