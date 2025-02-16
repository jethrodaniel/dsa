module DSA
  # A queue, implemented using a singly linked list.
  #
  # @example
  #   A queue containing 1 (front), then 2, then 3 (back):
  #
  #   (1)      (2)       (3)
  #   front -> middle -> back -> nil
  #
  class Queue
    # Create a new queue.
    #
    # @return [DSA::Queue] The new queue
    #
    def initialize
      @front = @back = nil
    end

    # Push an element to the back of the queue.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T] an element to push into the queue
    # @return [T] the new value at the back of the queue
    #
    def enqueue value
      if @back
        @back = @back.append value # rubocop:disable Style/RedundantSelfAssignment
      else
        @front = @back = DSA::SinglyLinkedList.new(value:)
      end

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

      @front.value
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

      @front = @front.next

      result
    end

    # Check if the queue is empty.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [bool] whether the queue is empty
    #
    def empty? = !@front

    # Count how many items are in the queue
    #
    # - Time: O(n), since we have to iterate the internal list and count the items.
    # - Space: O(1), no additional space based on input size
    #
    # @return [Integer] the list length
    #
    def length
      return 0 if empty?

      @front.length
    end

    # Return a string representation of the queue
    #
    # @return [String]
    def to_s
      items = @front.each.map(&:value).join(", ")
      "(front) #{items} (back)"
    end
  end
end
