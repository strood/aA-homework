require_relative "p05_hash_map"
require_relative "p04_linked_list"

class LRUCache
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key) #"Already in Cache"
      update_node!(@map.get(key)) #call helper to move it to mru, rerefernce map
      @map.get(key).val # return the val
    else #not in cache
      not_val = @prc.call(key) #this isnt actually used, cant get the prc calls to work
      val = key * key #so imitating on this line to get done(squaring value as proc is suppoesed to do)

      @store.append(key, val) #add new node to LL w val
      @map.set(key, @store.last) #refernce new node in map
      if self.count > @max #check to see if cache at max
        eject! #if at max, jcall eject helper to trim
      end
      return val #return val after  being computed(maybe with proc in future)
    end
  end

  def to_s
    "Map: " + @map.to_s + '\n' + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    @prc.call(key)
  end

  def update_node!(node)
    # suggested helper method; move a node to the end of the list
    node.remove  #remove it
    @store.append(node.key, node.val) #add it back on to cache, without recomupting, but now is mru
    @map.set(node.key, @store.last)
  end

  def eject!
    @map.delete(@store.first.key) #delete from the map
    @store.first.remove #remove from queue
  end
end
