class Integer
  # Integer#hash already implemented for you
end

class Array
  def hash
    ret = 0
    self.each do |el|
      if ret == 0
        ret = self[0]
      end
      ret = ret ^ el
    end
    ret.to_i
  end
end

class String
  def hash
    alpha = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    input = self.split("")
    input.each.with_index do |el, i|
      input[i] = alpha.index(el.downcase)
    end
    input.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    alpha = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    input = self.to_a.sort.flatten

    input.each.with_index do |el, i|
      if el.is_a?(Integer)
        input[i] = el
      elsif alpha.include?(el.downcase)
        input[i] = alpha.index(el.downcase)
      else
        input[i] = el.hash
      end
    end
    input.hash
  end
end
