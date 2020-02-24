class Stack
  def initialize
    # create ivar to store stack here!
    @ivar = []
  end

  def push(el)
    # adds an element to the stack
    @ivar.unshift(el)
  end

  def pop
    # removes one element from the stack
    @ivar.shift
  end

  def peek
    # returns, but doesn't remove, the top element in the stack
    @ivar[0]
  end
end

s = Stack.new
p "Stack"
p s.push(1)
p s.push(5)
p s.push(7)
p s.peek
p s.pop
p s.pop
p s

class Queue
  def initialize
    # create ivar to store stack here!
    @ivar = []
  end

  def enqueue(el)
    # adds an element to the stack
    @ivar << el
  end

  def dequeue
    # removes one element from the stack
    @ivar.shift
  end

  def peek
    # returns, but doesn't remove, the top element in the stack
    @ivar[0]
  end
end

g = Queue.new
p "Queue"
p g.enqueue(1)
p g.enqueue(5)
p g.enqueue(9)
p g.peek
p g.dequeue
p g.dequeue
p g

class Map
  def initialize
    @my_map = []
  end

  def contain(key)
    @my_map.any? { |el| el[0] == key }
  end

  def set(key, val)
    if !self.contain(key)
      @my_map << Array.new([key, val])
    else
      p "Duplicate Key"
    end
  end

  def get(key)
    if self.contain(key)
      @my_map.each { |el| return el[1] if el[0] == key }
    else
      p "Key not contained in map"
    end
  end

  def delete(key)
    if self.contain(key)
      @my_map.each { |el| @my_map.delete([el[0], el[1]]) if el[0] == key }
    else
      p "Key not contained in map"
    end
  end

  def show
    @my_map
  end
end

h = Map.new
p "Map"
p h.set("key1", 7)
p h.set("key2", 99)
p h.set("key3", "Hello Bob")
p h.show
h.set("key3", "Bye Bob")
h.get("key5")
p "GHi"
p h.get("key1")
p h.show
p h.contain("key2")
p h.contain("key4")
h.delete("key3")
h.delete("key5")
p h
