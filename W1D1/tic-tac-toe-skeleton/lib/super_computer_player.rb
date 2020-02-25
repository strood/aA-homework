require_relative "tic_tac_toe_node"

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    new_node = TicTacToeNode.new(game.board, mark)
    if new_node.children.any? { |child| child.winning_node?(mark) }
      win_node = new_node.children.select { |child| child.winning_node?(mark) }
      return win_node[0].prev_move_pos
    else
      raise "no non-losing nodes" if new_node.children.all? { |child| child.losing_node?(mark) }
      alt_node = new_node.children.select { |child| !child.losing_node?(mark) }

      return alt_node[0].prev_move_pos
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Pitiful Human Player")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
