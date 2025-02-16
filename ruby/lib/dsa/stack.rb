module DSA
  # A stack, implemented using a singly linked list.
  #
  class Stack
    # Create a new stack.
    #
    # @return [DSA::Stack] The new stack
    #
    def initialize
      @list = nil
    end

    # Push an element on top of the stack.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T] an element to push onto the stack
    # @return [DSA::SingleNode] the new top of the stack
    #
    def push value
      return (@list = list.prepend(value)) if list

      @list = DSA::SingleNode.new(value:)
    end

    # Return the top of the stack.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [DSA::SingleNode] the top of the stack
    #
    def peek
      raise ArgumentError, "stack must not be empty" if empty?

      list.value
    end

    # Pop an element from the top of the stack.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [DSA::SingleNode] the new top of the stack
    #
    def pop
      result = peek

      self.list = list.next

      result
    end

    # Check if the stack is empty.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [bool] whether the stack is empty
    #
    def empty? = !@list

    # Count how many items are in the stack
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
