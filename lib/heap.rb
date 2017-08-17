class BinaryMinHeap
  attr_reader :store, :prc

  def initialize(&prc)
      @prc = prc || Proc.new { |i, j| i <=> j }
      @store = []
  end

  def count
    @store.count
  end

  def extract
    return nil unless count > 1
    extracted = @store.first
    @store[0] = @store.pop
    self.class.heapify_down(@store, 0, &prc)
    extracted
  end

  def peek
    @store[0]
  end

  def push(val)
    @store.push(val)
    @store = self.class.heapify_up(@store, count - 1, count, &@prc)
  end

  public
  def self.child_indices(len, parent_index)
    left_child = 2 * parent_index + 1
    right_child = 2 * parent_index + 2
    child = []
    child << left_child unless left_child > len - 1
    child << right_child unless right_child > len -1
    return child
  end

  def self.parent_index(child_index)
    raise 'root has no parent' if child_index == 0
    return 0 if child_index < 2
    return (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |x, y| x <=> y }

    parent = array[parent_idx]
    left_child_idx = self.child_indices(len, parent_idx)[0]
    right_child_idx = self.child_indices(len, parent_idx)[1]

    children = left_child_idx ? [array[left_child_idx]] : []
    children << array[right_child_idx] if right_child_idx

    return array if children.all? { |child| prc.call(parent, child) <= 0 }
      if children.count == 1
        child_idx = left_child_idx
      else
        child_idx = prc.call(children[0], children[1]) < 0 ? left_child_idx : right_child_idx
      end
    array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]
    self.heapify_down(array, child_idx, len, &prc)
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    return array if child_idx == 0
    parent_idx = self.parent_index(child_idx)

    prc ||= Proc.new { |x, y| x <=> y }
    if prc.call(array[parent_idx], array[child_idx]) > 0
      array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]
      return self.heapify_up(array, parent_idx, len, &prc)
    end
    array
  end
end
