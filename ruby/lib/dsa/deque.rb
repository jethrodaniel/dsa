module DSA
  # A deque, implemented using a doubly linked list.
  #
  # @example
  #   A deque containing 1 (front), then 2, then 3 (back), where
  #
  #   - `->` represents `.next`, and
  #   - `<-` represents `.prev`:
  #
  #          (1)      (2)       (3)
  #   nil -> front -> middle -> back -> nil
  #   nil <-       <-        <-      <- nil
  #
  class Deque
    # Create a new deque.
    #
    # @return [DSA::Deque] The new deque
    #
    def initialize
      @front = @back = nil
    end

    # Push an element to the front of the deque.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T] an element to push into the deque
    # @return [T] the new value at the front of the deque
    #
    def push_front value
      if @front
        @front.prev = new_front = DSA::DoublyLinkedList.new(value:, next: @front)
        @front = new_front
      else
        @front = @back = DSA::DoublyLinkedList.new(value:)
      end

      value
    end

    # Push an element to the back of the deque.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T] an element to push into the deque
    # @return [T] the new value at the back of the deque
    #
    def push_back value
      if @back
        @back.next = new_back = DSA::DoublyLinkedList.new(value:, prev: @back)
        @back = new_back
      else
        @front = @back = DSA::DoublyLinkedList.new(value:)
      end

      value
    end

    # Return the front of the deque.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the value at the front of the deque
    #
    def peek_front
      raise ArgumentError, "deque must not be empty" if empty?

      @front.value
    end

    # Return the back of the deque.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the value at the back of the deque
    #
    def peek_back
      raise ArgumentError, "deque must not be empty" if empty?

      @back.value
    end

    # Pop an element from the front of the deque.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the new value at the front of the deque
    #
    def pop_front
      result = peek_front

      @front = @front.next

      if @front.nil? # empty
        @front = @back = nil
      else
        @front.prev = nil
      end

      result
    end

    # Pop an element from the back of the deque.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the new value at the back of the deque
    #
    def pop_back
      result = peek_back

      @back = @back.prev

      if @back.nil? # empty
        @back = @front = nil
      else
        @back.next = nil
      end

      result
    end

    # Check if the deque is empty.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [bool] whether the deque is empty
    #
    def empty? = !@front

    # Count how many items are in the deque
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

    # Return a string representation of the deque
    #
    # @return [String]
    def to_s
      items = @front.each.map(&:value).join(", ")
      "(front) #{items} (back)"
    end
  end
end
