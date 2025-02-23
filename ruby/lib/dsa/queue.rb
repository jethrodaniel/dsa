module DSA
  # A queue, implemented using a singly linked list.
  #
  class Queue
    # @return [DSA::Queue]
    #
    def initialize
      @front = @back = nil
      @list = DSA::SinglyLinkedList.new
    end

    # Push an item to the back of the queue.
    #
    # - Time: O(1), since we don't have to iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @param item [T] an item to push into the queue
    # @return [T] the new item at the back of the queue
    #
    def enqueue item
      if @list.empty?
        node = @list.append item
        @front = @back = node
      else
        @back = @list.append item
      end

      item
    end

    # Return the front of the queue.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the item at the front of the queue
    #
    def peek
      raise ArgumentError, "queue must not be empty" if empty?

      @front.value
    end

    # Pop an item from the front of the queue.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the new item at the front of the queue
    #
    def dequeue
      result = peek

      node = @list.delete node: @front
      @front = node.next

      result
    end

    # Check if the queue is empty.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [Boolean] whether the queue is empty
    #
    def empty? = @list.empty?

    # Count how many items are in the queue
    #
    # - Time: O(n), since we have to iterate the internal list and count the items.
    # - Space: O(1), no additional space based on input size
    #
    # @return [Integer] the list length
    #
    def length = @list.length

    # Return a string representation of the queue
    #
    # @return [String]
    #
    def to_s
      items = @list.each.map(&:value).join(", ")
      "(front) #{items} (back)"
    end
  end
end
