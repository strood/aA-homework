class PolyTreeNode
  attr_reader :parent, :children, :value

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(node)
    if @parent
      @parent.children.delete(self)
    end
    @parent = node
    if node
      node.children << self
    end
  end

  def add_child(node)
    if !self.children.include?(node)
      node.parent = self
    else
      return false
    end
  end

  def remove_child(child_node)
    if @children.include?(child_node)
      child_node.parent = nil
    else
      raise "invalid child removal"
    end
  end

  def add_child(child_node)
    if !self.children.include?(child_node)
      child_node.parent = self
    else
      raise "Already child of this node"
    end
  end

  def dfs(target_value)
    return self if self.value == target_value
    self.children.each do |child|
      result = child.dfs(target_value)
      return result if !result.nil?
    end
    nil
  end

  def bfs(target_value)
    queue = [self]
    while queue.length != 0
      a = queue.shift
      return a if a.value === target_value
      a.children.each { |child| queue << child }
    end
    nil
  end
end
