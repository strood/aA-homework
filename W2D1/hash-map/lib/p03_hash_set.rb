class HashSet
  attr_reader :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    if !self.include?(key)
      hkey = key.hash
      bucket = get_index(hkey)
      self[bucket] << key
      @count += 1
      true
      if count == num_buckets
        self.store = resize!
      end
    end
    false
  end

  def include?(key)
    hkey = key.hash
    return true if self[get_index(hkey)].include?(key)
    false
  end

  def remove(key)
    if self.include?(key)
      hkey = key.hash
      self[get_index(hkey)].slice!(self[get_index(hkey)].index(key))
      @count -= 1
      true
    end
    false
  end

  private

  def get_index(num)
    num % num_buckets
  end

  def store=(arr)
  end

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    index = get_index(num)
    @store[index]
  end

  def num_buckets
    @store.length
  end

  def resize!
    resized = HashSet.new(num_buckets * 2)
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
