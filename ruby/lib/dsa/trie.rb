module DSA
  # A trie, or a prefix tree.
  #
  # Each node contains a letter and an array of child nodes.
  #
  # The child nodes arrays have a fixed size, and currently only support a
  # limited subset of ASCII characters.
  #
  # Each node knows if it represents a complete word.
  #
  class Trie
    class Node
      UPPERCASE = ("A".."Z")
      LOWERCASE = ("a".."z")
      PUNCTUATION = ["'"].freeze
      ALPHABET_SIZE = [UPPERCASE, LOWERCASE, PUNCTUATION].sum(&:count)
      ROOT_LETTER = ""

      # @return [String] a single character, or the empty string
      attr_reader :letter

      # @return [Array<Node>] child nodes, one for each letter
      attr_accessor :children

      # @return [Boolean] whether this node represents a complete word
      attr_accessor :is_word

      # @param letter [String]
      #
      def initialize letter:
        @letter = letter
        @is_word = false
        @children = Array.new(ALPHABET_SIZE) { nil }
      end

      # @param letter [String]
      # @return [Boolean]
      #
      def child? letter
        ensure_valid_letter! letter
        index = letter.ord - "A".ord

        !!@children[index]
      end

      # @param letter [String]
      # @return [Node]
      #
      def child letter
        ensure_valid_letter! letter
        index = letter.ord - "A".ord

        @children[index]
      end

      # @param letter [String]
      # @return [Node]
      #
      def add letter
        ensure_valid_letter! letter
        index = letter.ord - "A".ord

        @children[index] = Node.new(letter:)
      end

      # @return [Boolean]
      #
      def leaf?
        @children.all?(&:nil?)
      end

      def is_word? = @is_word

      private

      def ensure_valid_letter! letter
        unless UPPERCASE.cover?(letter) ||
            LOWERCASE.cover?(letter) ||
            PUNCTUATION.include?(letter) ||
            letter == ROOT_LETTER
          raise ArgumentError, "invalid letter '#{letter}'"
        end
      end
    end

    def initialize
      @root = Node.new(letter: "")
    end

    # Check if the trie is empty.
    #
    # - Time: O(length of the alphabet), since we check the root node's children
    # - Space: O(1), no additional space based on input size
    #
    # @return [Boolean]
    #
    def empty? = @root.leaf?

    # Add a word to the trie.
    #
    # - Time: O(length of the string), since we iterate per character
    # - Space: O(1), no additional space based on input size
    #
    # @param word [String]
    # @return [Node]
    #
    def add word
      node = @root

      word.chars.each do |letter|
        node = if node.child? letter
          node.child letter
        else
          node.add letter
        end
      end

      node.is_word = true

      node
    end

    # Check if a word is in the trie.
    #
    # - Time: O(length of the string), since we iterate per character
    # - Space: O(1), no additional space based on input size
    #
    # @param word [String]
    # @return [Boolean]
    #
    def include? word
      node = @root

      word.chars.each do |letter|
        node = if node.child? letter
          node.child letter
        else
          return false
        end
      end

      node.is_word?
    end

    # Check if any words starting with the prefix are in the trie.
    #
    # - Time: O(length of the prefix), since we iterate per character
    # - Space: O(1), no additional space based on input size
    #
    # @param prefix [String]
    # @return [Boolean]
    #
    def include_prefix? prefix
      node = @root

      prefix.chars.each do |letter|
        node = if node.child? letter
          node.child letter
        else
          return false
        end
      end

      true
    end

    # Return all words starting with the prefix in the trie.
    #
    # - Time: O(n), since we iterate all nodes matching the prefix
    # - Space: O(n), since we recursively visit nodes and store words
    #
    # @param prefix [String]
    # @return [Array<String>]
    #
    def matches_for prefix
      node = @root
      words = []

      prefix.chars.each do |letter|
        node = if node.child? letter
          node.child letter
        else
          return []
        end
      end

      return [prefix] if node.leaf?

      _matches_for_prefix prefix, node, words
    end

    private

    def _matches_for_prefix prefix, node, words
      if node.leaf?
        words << prefix
        return words
      end

      words << prefix if node.is_word?

      node.children.each do |child|
        next if child.nil?

        _matches_for_prefix prefix + child.letter, child, words
      end

      words
    end
  end
end
