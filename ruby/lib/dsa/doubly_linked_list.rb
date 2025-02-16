module DSA
  # A doubly linked list.
  #
  class DoublyLinkedList
    attr_accessor :prev, :next, :value

    # Create a new node of type `T`.
    #
    # @param value [T] An element of type `T` to store in the list
    # @param prev [DSA::DoublyLinkedList, nil] The previous node in the list
    # @param next [DSA::DoublyLinkedList, nil] The next node in the list
    # @return [DSA::DoublyLinkedList] The new node
    #
    def initialize value:, prev: nil, next: nil
      @value = value
      @prev = prev
      @next = binding.local_variable_get(:next)
    end

    # Add an element to the front of the list.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [DSA::DoublyLinkedList] the new front node
    #
    def prepend(value) = self.class.new(value:, next: self)

    # Add an element to the end of the list.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [DSA::DoublyLinkedList] the new back node
    #
    def append value
      # @next = self.class.new(value:, prev: self)
      last = self
      each { |item| last = item }
      last.next = self.class.new(value:, prev: last)
    end

    # Yield each element of the list.
    #
    # - Time: O(n), since we iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @yield [DSA::DoublyLinkedList] each element of the list, if a block is given
    # @return [Enumerator<DSA::DoublyLinkedList>] if no block is given
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

    # Yield each element of the list in reverse order.
    #
    # - Time: O(n), since we iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @yield [DSA::DoublyLinkedList] each element of the list, if a block is given
    # @return [Enumerator<DSA::DoublyLinkedList>] if no block is given
    #
    def reverse_each
      return to_enum(__method__) unless block_given?

      curr = self

      while curr.prev
        yield curr
        curr = curr.prev
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
    # @return [DSA::DoublyLinkedList] the node at that index
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
    # - Time: O(1), since we don't have to iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @param node [DSA::DoublyLinkedList] the node to delete
    # @return [DSA::DoublyLinkedList] the new node
    #
    def delete node:
      raise ArgumentError, "node must be a node" unless node.is_a?(DSA::DoublyLinkedList)

      return node.next if node.prev.nil? # front

      node.prev.next = node.next
    end

    # Insert an element at the given index.
    #
    # - Time: O(n), we have to iterate the list to find where to insert the node
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @param index [Integer]
    # @return [DSA::DoublyLinkedList] the new node
    #
    def insert value:, index:
      raise ArgumentError, "index must be an integer" unless index.respond_to?(:to_i) && index.to_i == index
      raise ArgumentError, "index must be 0 or greater" unless index >= 0

      return self.class.new(value:, next: self) if index.zero?

      each.with_index do |item, i|
        return item.next = self.class.new(value:, prev: item, next: item.next) if i + 1 == index
      end

      raise ArgumentError, "index is too large"
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
