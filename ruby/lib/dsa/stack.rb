module DSA
  # A stack, implemented using a singly linked list.
  #
  # @example
  #   A stack containing 1 (bottom), then 2, then 3 (top):
  #
  #   (3)    (2)       (1)
  #   top -> middle -> bottom -> nil
  #
  class Stack
    # Create a new stack.
    #
    # @return [DSA::Stack] The new stack
    #
    def initialize
      @list = DSA::SinglyLinkedList.new
    end

    # Push an element on top of the stack.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T] an element to push onto the stack
    # @return [DSA::SinglyLinkedList::Node] the new top of the stack
    #
    def push value
      @list.prepend value
    end

    # Return the top of the stack.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [DSA::SinglyLinkedList::Node] the top of the stack
    #
    def peek
      raise ArgumentError, "stack must not be empty" if empty?

      @list.root.value
    end

    # Pop an element from the top of the stack.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [DSA::SinglyLinkedList::Node] the new top of the stack
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
    # @return [bool] whether the stack is empty
    #
    def empty? = @list.empty?

    # Count how many items are in the stack
    #
    # - Time: O(n), since we have to iterate the internal list and count the items.
    # - Space: O(1), no additional space based on input size
    #
    # @return [Integer] the list length
    #
    def length = @list.length

    # Return a string representation of the stack
    #
    # @return [String]
    def to_s
      items = @list.each.map(&:value).join(" ,").reverse
      "(bottom) #{items} (top)"
    end
  end
end
