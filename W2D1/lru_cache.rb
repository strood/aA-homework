class LRUCache
  attr_reader :cache, :size

  def initialize(size)
    @cache = Array.new
    @size = size
  end

  def count
    # returns number of elements currently in cache
    self.cache.length
  end

  def add(el)
    # adds element to cache according to LRU principle
    if self.cache.include?(el)
      self.cache.slice!(self.cache.index(el))
      cache.append(el)
    else
      cache.shift if self.cache.length == self.size
      cache.append(el)
    end
  end

  def show
    # shows the items in the cache, with the LRU item first
    print self.cache
  end

  private

  # helper methods go here!

end

johnny_cache = LRUCache.new(4)

p johnny_cache
p johnny_cache.cache
p johnny_cache.count
p johnny_cache.add("I walk the line")
p johnny_cache.add(5)

p johnny_cache.count # => returns 2

p johnny_cache.add([1, 2, 3])
p johnny_cache.add(5)
p johnny_cache.add(-5)
p johnny_cache.add({ a: 1, b: 2, c: 3 })
p johnny_cache.add([1, 2, 3, 4])
p johnny_cache.add("I walk the line")
p johnny_cache.add(:ring_of_fire)
p johnny_cache.add("I walk the line")
p johnny_cache.add({ a: 1, b: 2, c: 3 })

johnny_cache.show
puts
