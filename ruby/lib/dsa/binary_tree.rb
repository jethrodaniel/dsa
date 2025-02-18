module DSA
  # A binary tree.
  #
  # Each element in the list contains a value (`value`) and optional pointers
  # to its left and right children.
  #
  class BinaryTree
    # @return [DSA::BinaryTree::Node, nil] the root node of the tree
    attr_accessor :root

    class Node
      attr_accessor :value, :left, :right

      # Create a new node of type `T`.
      #
      # @param value [T] An element of type `T` to store in the tree
      # @param left [DSA::BinaryTree::Node, nil] The node's left child
      # @param right [DSA::BinaryTree::Node, nil] The node's right child
      # @return [DSA::BinaryTree::Node] The new node
      #
      def initialize value:, left: nil, right: nil
        @value = value
        @left = left
        @right = right
      end

      # @return [bool] whether the node is a leaf node
      def leaf? = left.nil? && right.nil?
    end

    # Check if the tree is empty.
    #
    # - Time: O(1), since we don't have to iterate the nodes
    # - Space: O(1), no additional space based on input size
    #
    # @return [bool] whether the tree is empty
    #
    def empty? = @root.nil?

    # Add an element to the tree.
    #
    # - Time: O(n), since we might have to iterate every node if unbalanced
    # - Space: O(n), since we recursively iterate each node
    #
    # @param value [T]
    # @return [DSA::BinaryTree::Node] the new node
    #
    def add value
      return @root = Node.new(value:) if empty?

      add_to node: @root, value:
    end

    # TODO
    def remove node
      # TODO
    end

    # Visit each node via an in-order depth-first-search.
    #
    # - Time: O(n), since we might have to iterate every node if unbalanced
    # - Space: O(n), since we recursively iterate each node
    #
    # @yield [DSA::BinaryTree::Node] each element, if a block is given
    # @return [Enumerator<DSA::BinaryTree::Node>] if no block is given
    #
    def each_in_order &block
      return to_enum(__method__) if block.nil?

      _each_in_order node: @root, &block
    end

    # Visit each node via an pre-order depth-first-search.
    #
    # - Time: O(n), since we might have to iterate every node if unbalanced
    # - Space: O(n), since we recursively iterate each node
    #
    # @yield [DSA::BinaryTree::Node] each element, if a block is given
    # @return [Enumerator<DSA::BinaryTree::Node>] if no block is given
    #
    def each_preorder &block
      return to_enum(__method__) if block.nil?

      _each_preorder node: @root, &block
    end

    # Visit each node via an post-order depth-first-search.
    #
    # - Time: O(n), since we might have to iterate every node if unbalanced
    # - Space: O(n), since we recursively iterate each node
    #
    # @yield [DSA::BinaryTree::Node] each element, if a block is given
    # @return [Enumerator<DSA::BinaryTree::Node>] if no block is given
    #
    def each_postorder &block
      return to_enum(__method__) if block.nil?

      _each_postorder node: @root, &block
    end

    # Visit each node via an level-order breadth-first-search.
    #
    # - Time: O(n), since we might have to iterate every node if unbalanced
    # - Space: O(n), since we iterate each node using a queue
    #
    # @yield [DSA::BinaryTree::Node] each element, if a block is given
    # @return [Enumerator<DSA::BinaryTree::Node>] if no block is given
    #
    def each_levelorder
      return to_enum(__method__) unless block_given?

      return if empty?

      queue = DSA::Queue.new
      queue.enqueue @root

      until queue.empty?
        node = queue.dequeue

        queue.enqueue node.left if node.left
        queue.enqueue node.right if node.right

        yield node
      end
    end

    # Check if an element exists in the tree.
    #
    # - Time: O(n), since we might have to iterate every node if unbalanced
    # - Space: O(n), since we recursively iterate each node
    #
    # @param value [T]
    # @return [bool] if the element exists in the tree
    #
    def include? value
      each_in_order { |item| return true if item.value == value }
      false
    end

    # Return a string representation of the tree
    #
    # @return [String]
    def to_s
      # TODO
    end

    private

    def add_to node:, value:
      if value < node.value
        return node.left = Node.new(value:) if node.left.nil?

        add_to(node: node.left, value:)
      else
        return node.right = Node.new(value:) if node.right.nil?

        add_to(node: node.right, value:)
      end
    end

    def _each_in_order node:, &block
      return if node.nil?

      _each_in_order node: node.left, &block
      block.call node
      _each_in_order node: node.right, &block
    end

    def _each_preorder node:, &block
      return if node.nil?

      block.call node
      _each_preorder node: node.left, &block
      _each_preorder node: node.right, &block
    end

    def _each_postorder node:, &block
      return if node.nil?

      _each_postorder node: node.left, &block
      _each_postorder node: node.right, &block
      block.call node
    end
  end
end
