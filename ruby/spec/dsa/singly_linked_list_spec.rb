RSpec.describe DSA::SinglyLinkedList do
  describe DSA::SinglyLinkedList::Node do
    describe "#value=" do
      it "updates the value" do
        node = described_class.new(value: 1)

        expect(node.value).to eq 1

        node.value = 42

        expect(node.value).to eq 42
      end
    end

    describe "#next=" do
      it "updates the pointer to the next node" do
        node = described_class.new(
          value: 1,
          next: described_class.new(value: 2)
        )

        expect(node.value).to eq 1
        expect(node.next).not_to be_nil

        node.next = nil

        expect(node.next).to be_nil
      end
    end
  end

  describe "#prepend" do
    it "prepends to the beginning of the list" do
      list = described_class.new
      list.prepend 3
      list.prepend 2
      list.prepend 1

      expect(list.root.value).to eq 1
      expect(list.root.next.value).to eq 2
      expect(list.root.next.next.value).to eq 3
      expect(list.root.next.next.next).to be_nil
    end
  end

  describe "#each" do
    context "when given a block" do
      it "calls the block for each element" do
        list = described_class.new
        list.prepend 2
        list.prepend 1

        items = list.each.map(&:value)

        expect(items).to eq [1, 2]
      end
    end

    context "when not given a block" do
      it "returns an enumerator" do
        list = described_class.new
        expect(list.each).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe "#length" do
    it "returns the number of items in the list" do
      list = described_class.new
      list.prepend 1
      list.prepend 2

      expect(list.length).to eq 2
    end
  end

  describe "#[]" do
    context "when index is invalid" do
      it "errors" do
        list = described_class.new

        expect { list[nil] }.to raise_error(ArgumentError, "index must be an integer")
      end
    end

    context "when index is negative" do
      it "errors" do
        list = described_class.new

        expect { list[-1] }.to raise_error(ArgumentError, "index must be 0 or greater")
      end
    end

    context "when index is too large" do
      it "errors" do
        list = described_class.new

        expect { list[42] }.to raise_error(ArgumentError, "index is too large")
      end
    end

    context "when index is 0" do
      it "returns the first element" do
        list = described_class.new
        list.prepend 3
        list.prepend 2
        list.prepend 1

        expect(list.root.value).to eq 1
        expect(list.root.next.value).to eq 2
        expect(list.root.next.next.value).to eq 3
        expect(list.root.next.next.next).to be_nil

        expect(list[0].value).to eq(1)
      end
    end

    context "when index is the length of the list - 1" do
      it "returns the last element" do
        list = described_class.new
        list.prepend 3
        list.prepend 2
        list.prepend 1

        expect(list.root.value).to eq 1
        expect(list.root.next.value).to eq 2
        expect(list.root.next.next.value).to eq 3
        expect(list.root.next.next.next).to be_nil

        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 2
        expect(list[2].value).to eq 3
      end
    end

    context "when index is in the middle" do
      it "returns the middle element" do
        list = described_class.new
        list.prepend 3
        list.prepend 2
        list.prepend 1

        expect(list.root.value).to eq 1
        expect(list.root.next.value).to eq 2
        expect(list.root.next.next.value).to eq 3
        expect(list.root.next.next.next).to be_nil

        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 2
        expect(list[2].value).to eq 3
      end
    end
  end

  describe "#delete" do
    context "when node is invalid" do
      it "errors" do
        list = described_class.new

        expect { list.delete(node: nil) }
          .to raise_error(ArgumentError, "node must be a node")
      end
    end

    context "when the node isn't in the list" do
      it "errors" do
        list = described_class.new
        node = described_class::Node.new(value: 42)

        expect { list.delete(node: node) }
          .to raise_error(ArgumentError, "node isn't in the list")
      end
    end

    context "when the node is at the beginning of the list" do
      it "deletes the node" do
        list = described_class.new
        list.prepend 2
        list.prepend 1

        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 2
        expect(list.length).to eq 2

        head = list.root
        tail = list.root.next

        result = list.delete node: head
        expect(result).to eq head

        expect(list.length).to eq 1
        expect(list[0].value).to eq 2
        expect(list.root).to eq tail
      end
    end

    context "when the node is at the end of the list" do
      it "deletes the node" do
        list = described_class.new
        list.prepend 2
        list.prepend 1

        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 2
        expect(list.length).to eq 2

        head = list.root
        tail = list.root.next

        result = list.delete node: tail
        expect(result).to eq tail

        expect(list.length).to eq 1
        expect(list[0].value).to eq 1
        expect(list.root).to eq head
      end
    end

    context "when the node is in the middle of the list" do
      it "deletes the node" do
        list = described_class.new
        list.prepend 3
        list.prepend 2
        list.prepend 1

        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 2
        expect(list[2].value).to eq 3
        expect(list.length).to eq 3

        head = list.root
        middle = head.next
        tail = middle.next

        result = list.delete node: middle
        expect(result).to eq middle

        expect(list.length).to eq 2
        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 3
        expect(list.root).to eq head
        expect(list.root.next).to eq tail
      end
    end
  end

  describe "#insert" do
    context "when index is invalid" do
      it "errors" do
        list = described_class.new

        expect { list.insert(value: 42, index: nil) }
          .to raise_error(ArgumentError, "index must be an integer")
      end
    end

    context "when index is negative" do
      it "errors" do
        list = described_class.new

        expect { list.insert(value: 42, index: -1) }
          .to raise_error(ArgumentError, "index must be 0 or greater")
      end
    end

    context "when index is too large" do
      it "errors" do
        list = described_class.new

        expect { list.insert(value: 42, index: 2) }
          .to raise_error(ArgumentError, "index is too large")
      end
    end

    context "when index is 0" do
      it "inserts at the beginning of the list" do
        list = described_class.new
        list.prepend 2
        list.prepend 1

        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 2
        expect(list.length).to eq 2

        result = list.insert value: 42, index: 0
        expect(result).to be_an_instance_of(described_class::Node)
        expect(result.value).to eq 42

        expect(list.length).to eq 3
        expect(list[0].value).to eq 42
        expect(list[1].value).to eq 1
        expect(list[2].value).to eq 2
        expect(list.root).to eq result
      end
    end

    context "when index is the length of the list" do
      it "inserts at the end of the list" do
        list = described_class.new
        list.prepend 2
        list.prepend 1

        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 2
        expect(list.length).to eq 2

        result = list.insert value: 42, index: 2
        expect(result).to be_an_instance_of(described_class::Node)
        expect(result.value).to eq 42

        expect(list.length).to eq 3
        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 2
        expect(list[2].value).to eq 42
      end
    end

    context "when index is in the middle" do
      it "inserts in the middle of the list" do
        list = described_class.new
        list.prepend 2
        list.prepend 1

        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 2
        expect(list.length).to eq 2

        result = list.insert value: 42, index: 1
        expect(result).to be_an_instance_of(described_class::Node)
        expect(result.value).to eq 42

        expect(list.length).to eq 3
        expect(list[0].value).to eq 1
        expect(list[1].value).to eq 42
        expect(list[2].value).to eq 2
      end
    end
  end

  describe "#append" do
    it "appends to the end of the list" do
      list = described_class.new
      list.append 1
      list.append 2

      expect(list[0].value).to eq 1
      expect(list[1].value).to eq 2
      expect(list.length).to eq 2
    end
  end

  describe "#include?" do
    it "returns whether an element exists in the list" do
      list = described_class.new
      list.append 1
      list.append 2

      expect(list[0].value).to eq 1
      expect(list[1].value).to eq 2
      expect(list.length).to eq 2

      expect(list.include?(1)).to be true
      expect(list.include?(2)).to be true
      expect(list.include?(42)).to be false
    end
  end

  describe "#empty?" do
    it "returns whether the list is empty" do
      list = described_class.new
      expect(list.empty?).to be true

      list.append 1
      expect(list.empty?).to be false
    end
  end

  describe "#to_s" do
    it "prints the list" do
      list = described_class.new
      list.append 1
      list.append 2
      list.append 3

      expect(list.to_s).to eq "1 -> 2 -> 3"
    end
  end
end
