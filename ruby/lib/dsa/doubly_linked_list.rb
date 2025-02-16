module DSA
  # A doubly linked list.
  #
  # Each element in the list contains a value (`value`), an optional pointer to
  # the next element in the list (`next`), and an optional pointer to the
  # previous element in the list (`prev`).
  #
  # @example
  #   A list containing [1, 2, 3], where
  #
  #   - `->` represents `.next`, and
  #   - `<-` represents `.prev`:
  #
  #           (1)    (2)     (3)
  #   nil -> head -> body -> tail -> nil
  #   nil <-      <-      <-      <- nil
  #
  class DoublyLinkedList
    # @return [DSA::DoublyLinkedList::Node, nil] the root node of the list
    attr_accessor :root

    class Node
      attr_accessor :prev, :next, :value

      # Create a new node of type `T`.
      #
      # @param value [T] An element of type `T` to store in the list
      # @param prev [DSA::DoublyLinkedList::Node, nil] The previous node in the list
      # @param next [DSA::DoublyLinkedList::Node, nil] The next node in the list
      # @return [DSA::DoublyLinkedList::Node] The new node
      #
      def initialize value:, prev: nil, next: nil
        @value = value
        @prev = prev
        @next = binding.local_variable_get(:next)
      end
    end

    # Add an element to the front of the list.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [DSA::DoublyLinkedList::Node] the new front node
    #
    def prepend value
      return @root = Node.new(value:, next: @root) if empty?

      old_root = @root
      new_root = Node.new(value:, next: @root)
      old_root.prev = new_root
      @root = new_root
    end

    # Add an element to the end of the list.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @return [DSA::DoublyLinkedList::Node] the new back node
    #
    def append value
      return @root = Node.new(value:, next: @root) if empty?

      last = @root
      each { |item| last = item }
      last.next = Node.new(value:, prev: last)
    end

    # Yield each element of the list.
    #
    # - Time: O(n), since we iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @yield [DSA::DoublyLinkedList::Node] each element of the list, if a block is given
    # @return [Enumerator<DSA::DoublyLinkedList::Node>] if no block is given
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

    # Yield each element of the list in reverse order, starting from `node`.
    #
    # - Time: O(n), since we iterate the list
    # - Space: O(1), no additional space based on input size
    #
    # @note `node` must be a member of the list.
    #
    # @param [DSA::DoublyLinkedList::Node] a member of the list
    # @yield [DSA::DoublyLinkedList::Node] each prior element, if a block is given
    # @return [Enumerator<DSA::DoublyLinkedList::Node>] if no block is given
    #
    def reverse_each node
      return to_enum(__method__, node) unless block_given?

      return unless node

      curr = node

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
    # @param node [DSA::DoublyLinkedList::Node] the node to delete
    # @return [DSA::SinglyLinkedList] the deleted node
    #
    def delete node:
      raise ArgumentError, "node must be a node" unless node.is_a?(DSA::DoublyLinkedList::Node)

      if @root == node
        @root = node.next
      else
        node.prev.next = node.next
      end

      node
    end

    # Insert an element at the given index.
    #
    # - Time: O(n), we have to iterate the list to find where to insert the node
    # - Space: O(1), no additional space based on input size
    #
    # @param value [T]
    # @param index [Integer]
    # @return [DSA::DoublyLinkedList::Node] the new node
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

    # Check if the list is empty.
    #
    # - Time: O(1), since we don't have to iterate the list.
    # - Space: O(1), no additional space based on input size
    #
    # @return [bool] whether the list is empty
    #
    def empty? = @root.nil?

    # Return a string representation of the list
    #
    # @return [String]
    def to_s = each.map(&:value).join(" -> ")
  end
end
