module DSA
  # A doubly linked list.
  #
  # Each item in the list contains a value, an optional pointer to the next
  # item in the list, and an optional pointer to the previous item in the
  # list.
  #
  class DoublyLinkedList
    class Node
      # @return [T]
      attr_accessor :value

      # @return [Node, nil]
      attr_accessor :next

      # @return [Node, nil]
      attr_accessor :prev

      # @param value [T]
      # @param prev [Node, nil]
      # @param next [Node, nil]
      # @return [Node] The new node
      #
      def initialize value:, prev: nil, next: nil
        @value = value
        @prev = prev
        @next = binding.local_variable_get(:next)
      end
    end

    # Add an item to the front of the list.
    #
    # - Time: O(1), since we don't have to iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [Node] the new front node
    #
    def prepend value
      return @root = Node.new(value:, next: @root) if empty?

      old_root = @root
      new_root = Node.new(value:, next: @root)
      old_root.prev = new_root
      @root = new_root
    end

    # Yield each item of the list.
    #
    # - Time: O(n), since we iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @yield [Node] each item of the list, if a block is given
    # @return [Enumerator<Node>] if no block is given
    #
    def each
      return to_enum(__method__) unless block_given?

      return if empty?

      curr = @root

      while curr.next
        yield curr
        curr = curr.next
      end

      yield curr
    end

    # Yield each item of the list in reverse order, starting from `node`.
    #
    # - Time: O(n), since we iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @param node [Node]
    # @yield [Node] each prior item, if a block is given
    # @return [Enumerator<Node>] if no block is given
    #
    def reverse_each node
      return to_enum(__method__, node) unless block_given?

      curr = node

      while curr.prev
        yield curr
        curr = curr.prev
      end

      yield curr
    end

    # Count how many items are in the list
    #
    # - Time: O(n), since we have to iterate the list and count the items
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
    # @return [Node]
    #
    def [] index
      raise ArgumentError, "index must be an integer" unless index.respond_to?(:to_i) && index.to_i == index
      raise ArgumentError, "index must be 0 or greater" unless index >= 0
      raise ArgumentError, "list is empty" if empty?

      each.with_index do |item, i|
        return item if i == index
      end

      raise ArgumentError, "index is too large"
    end

    # Delete an item
    #
    # - Time: O(n), since we have to iterate the list to find the previous node
    # - Space: O(1), no additional space based on input size
    #
    # @param node [Node] the node to delete
    # @return [Node] the deleted node
    #
    def delete node:
      raise ArgumentError, "node must be a node" unless node.is_a?(Node)

      if @root == node
        @root = node.next
      else
        node.prev.next = node.next
      end

      node
    end

    # Insert an item at the given index.
    #
    # - Time: O(n), we have to iterate the list to find the previous index's node
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @param index [Integer]
    # @return [Node] the new node
    #
    def insert value:, index:
      raise ArgumentError, "index must be an integer" unless index.respond_to?(:to_i) && index.to_i == index
      raise ArgumentError, "index must be 0 or greater" unless index >= 0

      return @root = Node.new(value:, next: @root) if index.zero?

      each.with_index do |item, i|
        return item.next = Node.new(value:, prev: item, next: item.next) if i + 1 == index
      end

      raise ArgumentError, "index is too large"
    end

    # Add an item to the end of the list.
    #
    # - Time: O(n), since we have to find the last node
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [Node] the new back node
    #
    def append value
      return @root = Node.new(value:) if empty?

      last = @root
      each { |item| last = item }
      last.next = Node.new(value:, prev: last)
    end

    # Check if an item exists in the list.
    #
    # Time: O(n), since we have to find the first node containing the item
    # Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [Boolean] if the item exists in the list
    #
    def include? value
      each { |item| return true if item.value == value }
      false
    end

    # Check if the list is empty.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [Boolean] whether the list is empty
    #
    def empty? = @root.nil?

    # Return a string representation of the list
    #
    # @return [String]
    #
    def to_s = each.map(&:value).join(" -> ")
  end
end
