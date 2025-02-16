module DSA
  # A singly linked list.
  #
  # Each element in the list contains a value (`value`) and an optional pointer
  # to the next element in the list (`next`).
  #
  # @example
  #   A list containing [1, 2, 3], where `->` represents `.next`:
  #
  #   (1)    (2)     (3)
  #   head -> body -> tail -> nil
  #
  class SinglyLinkedList
    attr_accessor :next, :value

    # Create a new node of type `T`.
    #
    # @param value [T] An element of type `T` to store in the list
    # @param next [DSA::SinglyLinkedList, nil] The next node in the list
    # @return [DSA::SinglyLinkedList] The new node
    #
    def initialize value:, next: nil
      @value = value
      @next = binding.local_variable_get(:next)
    end

    # Add an element to the front of the list.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [DSA::SinglyLinkedList] the new front node
    #
    def prepend(value) = self.class.new(value:, next: self)

    # Yield each element of the list.
    #
    # - Time: O(n), since we iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @yield [DSA::SinglyLinkedList] each element of the list, if a block is given
    # @return [Enumerator<DSA::SinglyLinkedList>] if no block is given
    #
    def each
      return to_enum(__method__) unless block_given?

      curr = self

      while curr.next
        yield curr
        curr = curr.next
      end

      yield curr
    end

    # Count how many items are in the list
    #
    # - Time: O(n), since we have to iterate the list and count the items.
    # - Space: O(1), no additional space based on input size
    #
    # @return [Integer] the list length
    #
    def length = each.count

    # Get the node at the given index
    #
    # - Time: O(n), since we have to iterate the list to find the node at that index
    # - Space: O(1), no additional space based on input size
    #
    # @return [DSA::SinglyLinkedList] the node at that index
    #
    def [] index
      raise ArgumentError, "index must be an integer" unless index.respond_to?(:to_i) && index.to_i == index
      raise ArgumentError, "index must be 0 or greater" unless index >= 0

      each.with_index do |item, i|
        return item if i == index
      end

      raise ArgumentError, "index is too large"
    end

    # Delete an element
    #
    # - Time: O(n), since we have to iterate the list to find the node.
    # - Space: O(1), no additional space based on input size
    #
    # @param node [DSA::SinglyLinkedList] the node to delete
    # @return [DSA::SinglyLinkedList] the next node after the deleted node
    #
    def delete node:
      raise ArgumentError, "node must be a node" unless node.is_a?(DSA::SinglyLinkedList)

      return node.next if self == node

      each do |item|
        if item.next == node
          item.next = node.next
          return item.next
        end
      end

      raise ArgumentError, "node isn't in the list"
    end

    # Insert an element at the given index.
    #
    # - Time: O(n), we have to iterate the list to find where to insert the node
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @param index [Integer]
    # @return [DSA::SinglyLinkedList] the new node
    #
    def insert value:, index:
      raise ArgumentError, "index must be an integer" unless index.respond_to?(:to_i) && index.to_i == index
      raise ArgumentError, "index must be 0 or greater" unless index >= 0

      return self.class.new(value:, next: self) if index.zero?

      each.with_index do |item, i|
        return item.next = self.class.new(value:, next: item.next) if i + 1 == index
      end

      raise ArgumentError, "index is too large"
    end

    # Append an element to the end of the list.
    #
    # - Time: O(n), since we have to find the last node
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [DSA::SinglyLinkedList] the new back node
    #
    def append value
      last = self
      each { |item| last = item }
      last.next = self.class.new(value:)
    end

    # Check if an element exists in the list.
    #
    # Time: O(n), since we have to find the first node containing the element
    # Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [bool] if the element exists in the list
    #
    def include? value
      each { |item| return true if item.value == value }
      false
    end
  end
end
