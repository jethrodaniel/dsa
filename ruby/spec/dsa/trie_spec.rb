RSpec.describe DSA::Trie do
  describe described_class::Node do
    it "has an initial children capacity" do
      node = described_class.new(letter: "a")
      expect(node.children.size).to eq 53
    end

    describe "#child?" do
      it "returns whether the letter is a child of the node" do
        node = described_class.new(letter: "a")
        expect(node.child?("b")).to be false

        node.add "b"
        expect(node.child?("b")).to be true
      end

      it "errors when letter is invalid" do
        node = described_class.new(letter: "a")
        expect { node.child?("$") }.to raise_error(ArgumentError, "invalid letter '$'")
      end
    end

    describe "#child" do
      it "returns the child node" do
        node = described_class.new(letter: "a")
        expect(node.child("b")).to be_nil

        node.add "b"
        result = node.child "b"
        expect(result).to be_a described_class
        expect(result.letter).to eq "b"
      end

      it "errors when letter is invalid" do
        node = described_class.new(letter: "a")
        expect { node.child("$") }.to raise_error(ArgumentError, "invalid letter '$'")
      end
    end

    describe "#add" do
      it "adds the letter" do
        node = described_class.new(letter: "a")
        expect(node.child?("b")).to be false

        node.add "b"
        expect(node.child?("b")).to be true
      end

      it "errors when letter is invalid" do
        node = described_class.new(letter: "a")
        expect { node.add("$") }.to raise_error(ArgumentError, "invalid letter '$'")
      end
    end

    describe "#leaf?" do
      it "returns whether the node is a leaf node" do
        node = described_class.new(letter: "a")
        expect(node.leaf?).to be true

        node.add "b"
        expect(node.leaf?).to be false
      end
    end
  end

  describe "#empty?" do
    it "returns whether the trie is empty" do
      trie = described_class.new
      expect(trie.empty?).to be true

      trie.add "hello"
      expect(trie.empty?).to be false
    end
  end

  describe "#add" do
    it "adds a word to the trie" do
      trie = described_class.new
      expect(trie.empty?).to be true

      node = trie.add "hello"
      expect(node).to be_a described_class::Node
      expect(node.letter).to eq "o"
      expect(trie.empty?).to be false
    end
  end

  describe "#include?" do
    it "returns whether a word is in the trie" do
      trie = described_class.new

      expect(trie.include?("sand")).to be false
      expect(trie.include?("sandwich")).to be false

      trie.add "sandwich"

      expect(trie.include?("sand")).to be false
      expect(trie.include?("sandwich")).to be true
    end
  end

  describe "#include_prefix?" do
    it "returns whether any words with the prefix are in the trie" do
      trie = described_class.new

      expect(trie.include_prefix?("sand")).to be false
      expect(trie.include_prefix?("sandwich")).to be false

      trie.add "sandwich"

      expect(trie.include_prefix?("sand")).to be true
      expect(trie.include_prefix?("sandwich")).to be true
    end
  end

  describe "#matches_for" do
    it "returns any words with the prefix in the trie" do
      trie = described_class.new

      expect(trie.matches_for("S")).to eq []
      expect(trie.matches_for("s")).to eq []
      expect(trie.matches_for("sand")).to eq []
      expect(trie.matches_for("sandwich")).to eq []

      trie.add "soup"
      trie.add "sandwich"
      trie.add "sandwiches"
      trie.add "sandy"
      trie.add "Sake"

      expect(trie.matches_for("S")).to eq ["Sake"]
      expect(trie.matches_for("s")).to eq ["sandwich", "sandwiches", "sandy", "soup"]
      expect(trie.matches_for("sand")).to eq ["sandwich", "sandwiches", "sandy"]
      expect(trie.matches_for("sandwich")).to eq ["sandwich", "sandwiches"]
      expect(trie.matches_for("sandwiches")).to eq ["sandwiches"]
    end
  end
end
