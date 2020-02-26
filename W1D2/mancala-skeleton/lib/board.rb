require "byebug"

class Board
  attr_accessor :cups, :p1, :p2

  def initialize(name1, name2)
    @p1 = name1
    @p2 = name2
    @cups = Array.new(14) { Array.new }
    self.place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    (0..5).each do |i|
      2.times { self.cups[i] << :stone }
    end
    (7..12).each do |i|
      2.times { self.cups[i] << :stone }
    end
  end

  def valid_move?(start_pos)
    return true if start_pos < 12 && start_pos > 0 && start_pos != 6
    raise "Invalid starting cup" if start_pos > 12 || start_pos < 0
    raise "Starting cup is empty" if self.cups[start_pos].length == 0
  end

  def make_move(start_pos, current_player_name)
    if start_pos < 7 && start_pos > 0
      pos = start_pos - 1
    else
      pos = start_pos
    end

    stones = self.cups[pos].length
    self.cups[pos] = []

    #debugger
    pos += 1
    pos = pos % 14

    if current_player_name == self.p2
      while stones > 0
        if pos != 6
          self.cups[pos] << :stone
          stones -= 1
        end
        if stones != 0
          pos += 1
          pos = pos % 14
        end
      end
    else
      while stones > 0
        if pos != 13
          self.cups[pos] << :stone
          stones -= 1
        end
        if stones != 0
          pos += 1
          pos = pos % 14
        end
      end
    end

    self.render

    if stones == 0
      next_turn = self.next_turn(pos, current_player_name)
      return next_turn
    end
  end

  def next_turn(ending_cup_idx, current_player_name)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx

    if current_player_name == self.p1
      if ending_cup_idx == 6
        return :prompt
      elsif self.cups[ending_cup_idx].length == 0
        return :switch
      else
        return ending_cup_idx
      end
    else
      if ending_cup_idx == 13
        return :prompt
      elsif self.cups[ending_cup_idx].length == 0
        return :switch
      else
        return ending_cup_idx
      end
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    return true if (0..5).all? { |i| self.cups[i].length == 0 }
    return true if (7..12).all? { |i| self.cups[i].length == 0 }
    false
  end

  def winner
    p1_score = self.cups[6].length
    p2_score = self.cups[13].length
    return self.p1 if p1_score > p2_score
    return self.p2 if p1_score < p2_score
    :draw
  end
end
