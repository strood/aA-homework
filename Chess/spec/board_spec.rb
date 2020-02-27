require "rspec"
require "board"

describe Board do
  subject(:board) do
    Board.new
  end

  describe "#initialize" do
    it "should hold a 8x8, 2 dimensional arrat(an array of arrays)" do
      expect(board.rows.class).to be(Array)
      expect(board.rows.length).to eq(8)
      expect(board.rows.all? { |col| col.length == 8 }).to eq(true)
    end

    it "fills the board with the correct pieces/nil on each spot to begin game" do
      expect(board.rows[2..5].all? { |col| col.all? { |pos| pos == nil } }).to eq(true)
      expect(board.rows[0..1].all? { |col| col.all? { |pos| pos.class == Piece } }).to eq(true)
      expect(board.rows[6..7].all? { |col| col.all? { |pos| pos.class == Piece } }).to eq(true)
    end
  end

  describe "#move_piece" do
    before(:each) do
      board.move_piece([1, 0], [2, 0])
    end

    it "should move the Piece from start_pos to end_pos" do
      expect(board.rows[2][0].class).to eq(Piece)
      expect(board.rows[1][0].class).to eq(NilClass)
    end

    it "should raise NoPieceError if no piece at start_pos" do
      expect do
        (board.move_piece([4, 0], [0, 2]))
      end.to raise_error(NoPieceError)
    end

    it "should raise 'InvalidEndPos' if unable to move to end_pos" do
      expect do
        (board.move_piece([1, 7], [1, 8]))
      end.to raise_error(InvalidEndPos)
    end
  end
end
