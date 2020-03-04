class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
    @next.prev = @prev
    @prev.next = @next
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = Node.new("head", "head")
    @tail = Node.new("tail", "tail")
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    return true if @head.next == @tail
    false
  end

  def get(key)
    self.each do |el|
      return el.val if el.key == key
    end
    nil
  end

  def include?(key)
    self.each do |el|
      return true if el.key == key
    end
    false
  end

  def append(key, val)
    insert = Node.new(key, val)

    last.next = insert
    insert.prev = last
    insert.next = @tail
    @tail.prev = insert
  end

  def update(key, val)
    self.each do |el|
      return el.val = val if el.key == key
    end
    nil
  end

  def remove(key)
    self.each do |el|
      return el.remove if el.key == key
    end
    nil
  end

  def each(&block)
    node = self.first
    while node.next != nil
      block.call(node)
      node = node.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
