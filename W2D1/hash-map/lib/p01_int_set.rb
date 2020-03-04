#A Set is a data type that can store unordered, unique items. Sets don't make any promises
# regarding insertion order, and they won't store duplicates. In exchange for those
# constraints, sets have remarkably fast retrieval time and can quickly look up the
# presence of values.
class MaxIntSet
  attr_reader :max, :store

  def initialize(max)
    @max = max
    @store = Array.new(max) { false }
  end

  def insert(num)
    raise "Out of bounds" if !is_valid?(num)
    if is_valid?(num)
      validate!(num)
    else
      false
    end
  end

  def remove(num)
    raise "Range Error" if !is_valid?(num)
    if is_valid?(num)
      validate!(num)
    else
      false
    end
  end

  def include?(num)
    raise "Range Error" if !is_valid?(num)
    return true if self.store[num] == true
    false
  end

  private

  def is_valid?(num)
    return true if num <= self.max && num >= 0
    false
  end

  def validate!(num)
    if !self.store[num]
      self.store[num] = true
    else
      self.store[num] = false
    end
  end
end

class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    if !self.include?(num)
      self[get_index(num)] << num
    end
    false
  end

  def remove(num)
    if self.include?(num)
      self[get_index(num)].slice!(self[get_index(num)].index(num))
    end
    false
  end

  def include?(num)
    return true if self[get_index(num)].include?(num)
    false
  end

  private

  attr_reader :store

  def get_index(num)
    num % num_buckets
  end

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    index = num % num_buckets
    store[index]
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count, :store

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    if !self.include?(num)
      self[get_index(num)] << num
      @count += 1
      true
      if count == num_buckets
        self.store = resize!
      end
    end
    false
  end

  def remove(num)
    if self.include?(num)
      self[get_index(num)].slice!(self[get_index(num)].index(num))
      @count -= 1
      true
    end
    false
  end

  def include?(num)
    return true if self[get_index(num)].include?(num)
    false
  end

  private

  def get_index(num)
    num % num_buckets
  end

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    index = num % num_buckets
    store[index]
  end

  def num_buckets
    store.length
  end

  def store=(arr)
  end

  def resize!
    resized = ResizingIntSet.new(num_buckets * 2)
    self.store.each do |bucket|
      bucket.each do |el|
        resized.insert(el)
      end
    end
    self.store.slice!(0..-1)
    resized.store.each do |bucket|
      self.store << bucket
    end
  end
end
