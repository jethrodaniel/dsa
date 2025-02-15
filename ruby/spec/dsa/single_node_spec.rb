RSpec.describe DSA::SingleNode do
  describe "#prepend" do
    let(:list) do
      head = described_class.new(value: 1)
      head.next = DSA::SingleNode.new(value: 2)
      head
    end

    it "prepends to the beginning of the list" do
      head = list

      expect(head.value).to eq 1
      expect(head.next.value).to eq 2
      expect(head.next.next).to be_nil

      head = head.prepend 42 # rubocop:disable Style/RedundantSelfAssignment

      expect(head.value).to eq 42
      expect(head.next.value).to eq 1
      expect(head.next.next.value).to eq 2
      expect(head.next.next.next).to be_nil
    end
  end

  describe "#each" do
    let(:list) do
      head = described_class.new(value: 1)
      head.next = DSA::SingleNode.new(value: 2)
      head
    end

    context "when given a block" do
      it "calls the block for each element" do
        items = []

        list.each { |item| items << item.value } # rubocop:disable Style/MapIntoArray

        expect(items).to eq [1, 2]
      end
    end

    context "when not given a block" do
      it "returns an enumerator" do
        expect(list.each).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe "#length" do
    let(:list) do
      head = described_class.new(value: 1)
      head.next = DSA::SingleNode.new(value: 2)
      head
    end

    it "returns the number of items in the list" do
      expect(list.length).to eq 2
    end
  end

  describe "#[]" do
    let(:list) { described_class.new(value: 1) }

    context "when index is invalid" do
      it "errors" do
        expect { list[nil] }.to raise_error(ArgumentError, "index must be an integer")
      end
    end

    context "when index is negative" do
      it "errors" do
        expect { list[-1] }.to raise_error(ArgumentError, "index must be 0 or greater")
      end
    end

    context "when index is too large" do
      it "errors" do
        expect { list[42] }.to raise_error(ArgumentError, "index is too large")
      end
    end

    context "when index is 0" do
      it "returns the first element" do
        head = list

        expect(head.value).to eq 1
        expect(head.next).to be_nil

        node = head[0]
        expect(node).to eq(head)
      end
    end

    context "when index is the length of the list - 1" do
      it "returns the last element" do
        head = list
        head.next = tail = described_class.new(value: 2)

        expect(head.value).to eq 1
        expect(head.next.value).to eq 2
        expect(head.next.next).to be_nil

        node = head[1]
        expect(node).to eq(tail)
      end
    end

    context "when index is in the middle" do
      it "returns the middle element" do
        head = list
        head.next = middle = described_class.new(value: 2)
        middle.next = described_class.new(value: 3)

        expect(head.value).to eq 1
        expect(head.next.value).to eq 2
        expect(head.next.next.value).to eq 3
        expect(head.next.next.next).to be_nil

        node = head[1]
        expect(node).to eq(middle)
      end
    end
  end

  describe "#delete" do
    let(:list) do
      head = described_class.new(value: 1)
      head.next = DSA::SingleNode.new(value: 2)
      head
    end

    context "when node is invalid" do
      it "errors" do
        expect { list.delete(node: nil) }
          .to raise_error(ArgumentError, "node must be a node")
      end
    end

    context "when the node isn't in the list" do
      it "errors" do
        node = described_class.new(value: 42)
        expect { list.delete(node: node) }
          .to raise_error(ArgumentError, "node isn't in the list")
      end
    end

    context "when the node is at the beginning of the list" do
      it "deletes the node" do
        head = list
        tail = described_class.new(value: 2)
        head.next = tail

        expect(head.value).to eq 1
        expect(head.next.value).to eq 2
        expect(head.next.next).to be_nil

        new_head = head.delete node: head
        expect(new_head).to eq(tail)

        head = new_head
        expect(head.value).to eq 2
        expect(head.next).to be_nil
      end
    end

    context "when the node is at the end of the list" do
      it "deletes the node" do
        head = list
        tail = described_class.new(value: 2)
        head.next = tail

        expect(head.value).to eq 1
        expect(head.next.value).to eq 2
        expect(head.next.next).to be_nil

        new_head = head.delete node: tail
        expect(new_head).to eq(tail)

        expect(head.value).to eq 1
        expect(head.next).to be_nil
      end
    end

    context "when the node is in the middle of the list" do
      it "deletes the node" do
        head = list
        middle = described_class.new(value: 2)
        head.next = middle
        tail = described_class.new(value: 3)
        middle.next = tail

        expect(head.value).to eq 1
        expect(head.next.value).to eq 2
        expect(head.next.next.value).to eq 3
        expect(head.next.next.next).to be_nil

        node = head.delete node: middle
        expect(node).to eq(middle)

        expect(head.value).to eq 1
        expect(head.next.value).to eq 3
        expect(head.next.next).to be_nil
      end
    end
  end

  describe "#insert" do
    let(:list) { described_class.new(value: 1) }

    context "when index is invalid" do
      it "errors" do
        expect { list.insert(value: 42, index: nil) }
          .to raise_error(ArgumentError, "index must be an integer")
      end
    end

    context "when index is negative" do
      it "errors" do
        expect { list.insert(value: 42, index: -1) }
          .to raise_error(ArgumentError, "index must be 0 or greater")
      end
    end

    context "when index is too large" do
      it "errors" do
        expect { list.insert(value: 42, index: 2) }
          .to raise_error(ArgumentError, "index is too large")
      end
    end

    context "when index is 0" do
      it "inserts at the beginning of the list" do
        head = list

        expect(head.value).to eq 1
        expect(head.next).to be_nil

        new_node = head.insert value: 42, index: 0
        expect(new_node).to be_an_instance_of(DSA::SingleNode)

        head = new_node
        expect(head.value).to eq 42
        expect(head.next.value).to eq 1
        expect(head.next.next).to be_nil
      end
    end

    context "when index is the length of the list" do
      it "inserts at the end of the list" do
        head = list

        expect(head.value).to eq 1
        expect(head.next).to be_nil

        new_node = head.insert value: 42, index: 1
        expect(new_node).to be_an_instance_of(DSA::SingleNode)

        expect(head.value).to eq 1
        expect(head.next.value).to eq 42
        expect(head.next.next).to be_nil
      end
    end

    context "when index is in the middle" do
      it "inserts in the middle of the list" do
        head = list
        head.next = described_class.new(value: 2)

        expect(head.value).to eq 1
        expect(head.next.value).to eq 2
        expect(head.next.next).to be_nil

        new_node = head.insert value: 42, index: 1
        expect(new_node).to be_an_instance_of(DSA::SingleNode)

        expect(head.value).to eq 1
        expect(head.next.value).to eq 42
        expect(head.next.next.value).to eq 2
        expect(head.next.next.next).to be_nil
      end
    end
  end

  describe "#append" do
    let(:list) do
      head = described_class.new(value: 1)
      head.next = DSA::SingleNode.new(value: 2)
      head
    end

    it "appends to the end of the list" do
      head = list

      expect(head.value).to eq 1
      expect(head.next.value).to eq 2
      expect(head.next.next).to be_nil

      head.append 42

      expect(head.value).to eq 1
      expect(head.next.value).to eq 2
      expect(head.next.next.value).to eq 42
      expect(head.next.next.next).to be_nil
    end
  end
end
