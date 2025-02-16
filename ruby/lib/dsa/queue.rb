module DSA
  # A queue, implemented using a singly linked list.
  #
  class Queue
    # Create a new queue.
    #
    # @return [DSA::Queue] The new queue
    #
    def initialize
      @list = nil
    end

    # Push an element to the end of the queue.
    #
    # - Time: O(n), since we have to iterate the list to add to the end.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T] an element to push into the queue
    # @return [T] the new value at the back of the queue
    #
    def enqueue value
      # TODO: make this O(1) using a circular linked list
      if list
        list.append value
        return list
      end

      @list = DSA::SingleNode.new(value:)

      value
    end

    # Return the front of the queue.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the value at the front of the queue
    #
    def peek
      raise ArgumentError, "queue must not be empty" if empty?

      list.value
    end

    # Pop an element from the front of the queue.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the new value at the front of the queue
    #
    def dequeue
      result = peek

      self.list = list.next

      result
    end

    # Check if the queue is empty.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [bool] whether the queue is empty
    #
    def empty? = !@list

    # Count how many items are in the queue
    #
    # - Time: O(n), since we have to iterate the internal list and count the items.
    # - Space: O(1), no additional space based on input size
    #
    # @return [Integer] the list length
    #
    def length
      return 0 if empty?

      list.length
    end

    private

    attr_accessor :list
  end
end
