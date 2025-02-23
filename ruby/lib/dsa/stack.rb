module DSA
  # A stack, implemented using a singly linked list.
  #
  class Stack
    # @return [Stack]
    #
    def initialize
      @list = DSA::SinglyLinkedList.new
    end

    # Push an item on top of the stack.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param item [T] an item to push onto the stack
    # @return [T] the new item on top of the stack
    #
    def push item
      @list.prepend(item).value
    end

    # Return the top of the stack.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the item on top of the stack
    #
    def peek
      raise ArgumentError, "stack must not be empty" if empty?

      @list.root.value
    end

    # Pop an item from the top of the stack.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [T] the item we popped off the top of the stack
    #
    def pop
      result = peek

      @list.delete node: @list.root

      result
    end

    # Check if the stack is empty.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [Boolean] whether the stack is empty
    #
    def empty? = @list.empty?

    # Count how many items are in the stack
    #
    # - Time: O(n), since we have to iterate the internal list and count the items
    # - Space: O(1), no additional space based on input size
    #
    # @return [Integer] the list length
    #
    def length = @list.length

    # Return a string representation of the stack
    #
    # @return [String]
    #
    def to_s
      items = @list.each.map(&:value).join(" ,").reverse
      "(bottom) #{items} (top)"
    end
  end
end
