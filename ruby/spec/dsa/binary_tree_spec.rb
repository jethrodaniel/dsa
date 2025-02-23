RSpec.describe DSA::BinaryTree do
  describe described_class::Node do
    describe "#value=" do
      it "updates the value" do
        node = described_class.new(value: 1)

        expect(node.value).to eq 1

        node.value = 42

        expect(node.value).to eq 42
      end
    end

    describe "#left=" do
      it "updates the pointer to the left child" do
        node = described_class.new(value: 1)

        expect(node.value).to eq 1
        expect(node.left).to be_nil

        node.left = described_class.new(value: 42)

        expect(node.left).not_to be_nil
        expect(node.left.value).to eq 42
      end
    end

    describe "#right=" do
      it "updates the pointer to the right child" do
        node = described_class.new(value: 1)

        expect(node.value).to eq 1
        expect(node.right).to be_nil

        node.right = described_class.new(value: 42)

        expect(node.right).not_to be_nil
        expect(node.right.value).to eq 42
      end
    end

    describe "#leaf?" do
      it "returns whether the node is a leaf node" do
        node = described_class.new(value: 1)
        expect(node.leaf?).to be true

        node.right = described_class.new(value: 42)
        expect(node.leaf?).to be false

        node.right = nil
        node.left = described_class.new(value: 42)
        expect(node.leaf?).to be false
      end
    end
  end

  describe "#empty?" do
    it "returns whether the tree is empty" do
      tree = described_class.new
      expect(tree.empty?).to be true

      tree.add 1
      expect(tree.empty?).to be false
    end
  end

  describe "#each_in_order" do
    context "when given a block" do
      it "calls the block for each node" do
        tree = described_class.new
        #   1
        #  / \
        # 2   3
        #    / \
        #       4
        tree.add 1
        tree.add 3
        tree.add 2
        tree.add 4
        items = tree.each_in_order.map(&:value)
        expect(items).to eq [1, 2, 3, 4]

        empty_tree = described_class.new
        items = empty_tree.each_in_order.map(&:value)
        expect(items).to eq []
      end
    end

    context "when not given a block" do
      it "returns an enumerator" do
        tree = described_class.new
        expect(tree.each_in_order).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe "#each_preorder" do
    context "when given a block" do
      it "calls the block for each node" do
        tree = described_class.new
        tree.add 1
        tree.add 3
        tree.add 2
        tree.add 4
        items = tree.each_preorder.map(&:value)
        expect(items).to eq [1, 3, 2, 4]

        empty_tree = described_class.new
        items = empty_tree.each_preorder.map(&:value)
        expect(items).to eq []
      end
    end

    context "when not given a block" do
      it "returns an enumerator" do
        tree = described_class.new
        expect(tree.each_preorder).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe "#each_postorder" do
    context "when given a block" do
      it "calls the block for each node" do
        tree = described_class.new
        tree.add 1
        tree.add 3
        tree.add 2
        tree.add 4
        items = tree.each_postorder.map(&:value)
        expect(items).to eq [2, 4, 3, 1]

        empty_tree = described_class.new
        items = empty_tree.each_postorder.map(&:value)
        expect(items).to eq []
      end
    end

    context "when not given a block" do
      it "returns an enumerator" do
        tree = described_class.new
        expect(tree.each_postorder).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe "#each_levelorder" do
    context "when given a block" do
      it "calls the block for each node" do
        tree = described_class.new
        tree.add 1
        tree.add 3
        tree.add 2
        tree.add 4
        items = tree.each_levelorder.map(&:value)
        expect(items).to eq [1, 3, 2, 4]

        empty_tree = described_class.new
        items = empty_tree.each_levelorder.map(&:value)
        expect(items).to eq []
      end
    end

    context "when not given a block" do
      it "returns an enumerator" do
        tree = described_class.new
        expect(tree.each_levelorder).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe "#add" do
    context "when adding to an empty tree" do
      it "adds the value to the tree" do
        tree = described_class.new
        expect(tree.empty?).to be true

        result = tree.add 42
        expect(result).to be_an_instance_of(described_class::Node)
        expect(result.value).to eq 42
        expect(tree.empty?).to be false
      end
    end

    context "when adding to a non-empty tree" do
      it "adds the value to the correct child of the tree" do
        tree = described_class.new
        tree.add 0
        expect(tree.root.value).to eq 0
        expect(tree.root.left).to be_nil
        expect(tree.root.right).to be_nil

        result = tree.add 42
        expect(result).to be_an_instance_of(described_class::Node)
        expect(result.value).to eq 42

        expect(tree.root.left).to be_nil
        expect(tree.root.right.value).to eq 42
      end
    end
  end

  describe "#include?" do
    it "returns whether an element exists in the tree" do
      tree = described_class.new
      tree.add 1
      tree.add 4
      tree.add 2
      tree.add 2

      expect(tree.include?(42)).to be false

      tree.add 42

      expect(tree.include?(42)).to be true
    end
  end

  describe "#remove" do
    it "removes the node from the tree" do
      skip "TODO"

      tree = described_class.new
      node = tree.add 1

      result = tree.remove node
      expect(result).to eq node
    end
  end

  describe "#to_s" do
    it "prints the tree" do
      skip "TODO"

      tree = described_class.new
      tree.add 1
      tree.add 4
      tree.add 2
      tree.add 2

      expect(tree.to_s).to eq "TODO"
    end
  end
end
