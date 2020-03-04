require_relative "p04_linked_list"

class HashMap
  include Enumerable
  attr_accessor :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    @store[bucket(key)].include?(key)
  end

  def set(key, val)
    if self.include?(key)
      @store[bucket(key)].update(key, val)
      true
    else
      @store[bucket(key)].append(key, val)
      @count += 1
      true
      if @count == num_buckets
        self.store = resize!
      end
    end
    false
  end

  def get(key)
    @store[bucket(key)].get(key)
  end

  def delete(key)
    @store[bucket(key)].remove(key)
    @count -= 1
  end

  def each(&block)
    @store.each do |bucket|
      bucket.each do |node|
        block.call(node.key, node.val)
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    resized = HashMap.new(num_buckets * 2)
    self.store.each do |bucket|
      bucket.each do |node|
        resized.set(node.key, node.val)
      end
    end
    self.store.slice!(0..-1)
    resized.store.each do |bucket|
      self.store << bucket
    end
  end

  def store=(arr)
  end

  def bucket(key)
    hkey = key.hash
    hkey % num_buckets
  end
end
