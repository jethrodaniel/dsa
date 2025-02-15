module DSA
  # A singly linked list.
  #
  # head -> body -> tail -> nil
  #
  class SingleNode
    attr_accessor :next
    attr_reader :value

    def initialize value:, next: nil
      @value = value
      @next = binding.local_variable_get(:next)
    end

    # Append an element to the end of the list.
    #
    # Time: O(n), since we have to find the last node
    # Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [DSA::SingleNode] the new node
    #
    def append value
      curr = self
      curr = curr.next while curr.next
      curr.next = DSA::SingleNode.new(value:)
    end

    # Add an element to the beginning of the list.
    #
    # Time: O(1), since we don't have to iterate the list.
    # Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [DSA::SingleNode] the new node
    #
    def prepend(value) = DSA::SingleNode.new(value:, next: self)

    # Insert an element at the given index.
    #
    # Time: O(n), we have to iterate the list to find where to insert the node
    # Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @param index [Integer]
    # @return [DSA::SingleNode] the new node
    #
    def insert value:, index:
      raise ArgumentError, "index must be an integer" unless index.respond_to?(:to_i) && index.to_i == index
      raise ArgumentError, "index must be 0 or greater" unless index >= 0

      return DSA::SingleNode.new(value:, next: self) if index.zero?

      curr = self
      i = 1

      while i < index && curr.next
        curr = curr.next
        i += 1
      end

      raise ArgumentError, "index is too large" if i < index

      curr.next = DSA::SingleNode.new(value:, next: curr.next)
    end

    # Delete an element
    #
    # Time: O(1), since we just have to iterate the list to find the node.
    # Space: O(1), no additional space based on input size
    #
    # @param node [DSA::SingleNode] the node to delete
    # @return [DSA::SingleNode] the deleted node
    #
    def delete node:
      raise ArgumentError, "node must be a node" unless node.is_a?(DSA::SingleNode)

      curr = self

      return node.next if curr == node

      while curr.next
        if curr.next == node
          curr.next = node.next
          return node
        end

        curr = curr.next
      end

      raise ArgumentError, "node isn't in the list"
    end

    # Count how many items are in the list
    #
    # Time: O(n), since we have to iterate the list and count the items.
    # Space: O(1), no additional space based on input size
    #
    # @return [Integer] the list length
    #
    def length
      curr = self
      num_items = 1

      while curr.next
        num_items += 1
        curr = curr.next
      end

      num_items
    end

    # Get the node at the given index
    #
    # Time: O(n), since we have to iterate the list to find the node at that index
    # Space: O(1), no additional space based on input size
    #
    # @return [DSA::SingleNode] the node at that index
    #
    def [] index
      raise ArgumentError, "index must be an integer" unless index.respond_to?(:to_i) && index.to_i == index
      raise ArgumentError, "index must be 0 or greater" unless index >= 0

      return self if index.zero?

      curr = self
      i = 0

      while curr.next
        return curr if i == index

        i += 1
        curr = curr.next
      end

      raise ArgumentError, "index is too large" if i < index

      curr
    end
  end
end
