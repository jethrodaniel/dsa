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
      @list = DSA::DoublyLinkedList.new
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
      if @list.empty?
        node = @list.append value
        @front = @back = node
      else
        @front = @list.prepend value
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
      if @list.empty?
        node = @list.append value
        @front = @back = node
      else
        @back = @list.append value
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

      node = @list.delete node: @front
      @front = node.next

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

      node = @list.delete node: @back
      @back = node.prev

      result
    end

    # Check if the deque is empty.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [bool] whether the deque is empty
    #
    def empty? = @list.empty?

    # Count how many items are in the deque
    #
    # - Time: O(n), since we have to iterate the internal list and count the items.
    # - Space: O(1), no additional space based on input size
    #
    # @return [Integer] the list length
    #
    def length = @list.length

    # Return a string representation of the deque
    #
    # @return [String]
    def to_s
      items = @list.each.map(&:value).join(", ")
      "(front) #{items} (back)"
    end
  end
end
