RSpec.describe DSA::DoublyLinkedList do
  let(:list) do
    head = described_class.new(value: 1)
    head.next = middle = described_class.new(value: 2, prev: head)
    middle.next = described_class.new(value: 3, prev: middle)
    middle.prev = head
    head
  end

  describe "#value=" do
    it "updates the value" do
      head = list

      expect(head.value).to eq 1

      head.value = 42

      expect(head.value).to eq 42
    end
  end

  describe "#prev=" do
    it "updates the pointer to the previous node" do
      second = list.next

      expect(second.value).to eq 2
      expect(second.prev.value).to eq 1

      second.prev = nil

      expect(second.prev).to be_nil
    end
  end

  describe "#next=" do
    it "updates the pointer to the next node" do
      head = list

      expect(head.value).to eq 1
      expect(head.next).not_to be_nil

      head.next = nil

      expect(head.next).to be_nil
    end
  end

  describe "#prepend" do
    it "prepends to the beginning of the list" do
      head = list

      expect(head.value).to eq 1
      expect(head.next.value).to eq 2
      expect(head.next.next.value).to eq 3
      expect(head.next.next.next).to be_nil

      head = head.prepend 42 # rubocop:disable Style/RedundantSelfAssignment

      expect(head.value).to eq 42
      expect(head.next.value).to eq 1
      expect(head.next.next.value).to eq 2
      expect(head.next.next.next.value).to eq 3
      expect(head.next.next.next.next).to be_nil
    end
  end

  describe "#each" do
    context "when given a block" do
      it "calls the block for each element" do
        items = []

        list.each { |item| items << item.value } # rubocop:disable Style/MapIntoArray

        expect(items).to eq [1, 2, 3]
      end
    end

    context "when not given a block" do
      it "returns an enumerator" do
        expect(list.each).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe "#reverse_each" do
    context "when given a block" do
      it "calls the block for each element" do
        items = []

        middle = list.next
        expect(middle.value).to eq 2
        tail = middle.next
        expect(tail.value).to eq 3

        tail.reverse_each { |item| items << item.value }

        expect(items).to eq [3, 2, 1]
      end
    end

    context "when not given a block" do
      it "returns an enumerator" do
        expect(list.reverse_each).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe "#length" do
    it "returns the number of items in the list" do
      expect(list.length).to eq 3
    end
  end

  describe "#[]" do
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
        expect(head.next.value).to eq 2
        expect(head.next.next.value).to eq 3
        expect(head.next.next.next).to be_nil

        node = head[0]
        expect(node).to eq(head)
      end
    end

    context "when index is the length of the list - 1" do
      it "returns the last element" do
        head = list

        expect(head.value).to eq 1
        expect(head.next.value).to eq 2
        expect(head.next.next.value).to eq 3
        expect(head.next.next.next).to be_nil

        tail = head.next.next

        node = head[2]
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
      head.next = described_class.new(value: 2, prev: head)
      head
    end

    context "when node is invalid" do
      it "errors" do
        expect { list.delete(node: nil) }
          .to raise_error(ArgumentError, "node must be a node")
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
        tail = described_class.new(value: 2, prev: head)
        head.next = tail

        expect(head.value).to eq 1
        expect(head.next.value).to eq 2
        expect(head.next.next).to be_nil

        result = head.delete node: tail
        expect(result).to be_nil

        expect(head.value).to eq 1
        expect(head.next).to be_nil
      end
    end

    context "when the node is in the middle of the list" do
      it "deletes the node" do
        head = list
        middle = described_class.new(value: 2, prev: head)
        head.next = middle
        tail = described_class.new(value: 3, prev: middle)
        middle.next = tail

        expect(head.value).to eq 1
        expect(head.next.value).to eq 2
        expect(head.next.next.value).to eq 3
        expect(head.next.next.next).to be_nil

        node = head.delete node: middle
        expect(node).to eq(tail)

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
        expect(new_node).to be_an_instance_of(described_class)

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
        expect(new_node).to be_an_instance_of(described_class)

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
        expect(new_node).to be_an_instance_of(described_class)

        expect(head.value).to eq 1
        expect(head.next.value).to eq 42
        expect(head.next.next.value).to eq 2
        expect(head.next.next.next).to be_nil
      end
    end
  end

  describe "#append" do
    it "appends to the end of the list" do
      head = list

      expect(head.value).to eq 1
      expect(head.next.value).to eq 2
      expect(head.next.next.value).to eq 3
      expect(head.next.next.next).to be_nil

      head.append 42

      expect(head.value).to eq 1
      expect(head.next.value).to eq 2
      expect(head.next.next.value).to eq 3
      expect(head.next.next.next.value).to eq 42
      expect(head.next.next.next.next).to be_nil
    end
  end

  describe "#include?" do
    it "returns whether an element exists in the list" do
      head = list

      expect(head.value).to eq 1
      expect(head.next.value).to eq 2
      expect(head.next.next.value).to eq 3
      expect(head.next.next.next).to be_nil

      expect(head.include?(1)).to be true
      expect(head.include?(2)).to be true
      expect(head.include?(3)).to be true
      expect(head.include?(42)).to be false
    end
  end
end
