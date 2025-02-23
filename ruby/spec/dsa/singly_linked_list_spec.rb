RSpec.describe DSA::SinglyLinkedList do
  def generate_lists from, to
    bench_range(from, to).map do |n|
      list = described_class.new
      1.upto(n).each { list.prepend _1 }
      list
    end
  end

  describe described_class::Node do
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
        expect(node.next).not_to be_nil

        node.next = nil
        expect(node.next).to be_nil
      end
    end
  end

  it "takes up 56 bytes per item" do
    lists = 1.upto(3).map do |n|
      list = described_class.new
      1.upto(n).each { list.prepend _1 }
      list
    end

    sizeof = ->(obj) do
      size = ObjectSpace.memsize_of obj

      obj.instance_variables.each do |ivar_name|
        ivar = obj.instance_variable_get(ivar_name)
        size += sizeof.call(ivar)
        size += Fiddle::SIZEOF_VOIDP
      end

      size
    end

    expect(lists[0].length).to eq 1
    expect(sizeof.call(lists[0])).to eq 104
    expect(sizeof.call(lists[0])).to eq 48 + 56 * 1

    expect(lists[1].length).to eq 2
    expect(sizeof.call(lists[1])).to eq 160
    expect(sizeof.call(lists[1])).to eq 48 + 56 * 2

    expect(lists[2].length).to eq 3
    expect(sizeof.call(lists[2])).to eq 216
    expect(sizeof.call(lists[2])).to eq 48 + 56 * 3
  end

  describe "#prepend" do
    it "prepends to the beginning of the list" do
      list = described_class.new

      list.prepend 2
      expect(list[0].value).to eq 2

      list.prepend 1
      expect(list[0].value).to eq 1
      expect(list[1].value).to eq 2
    end

    it "has O(1) time complexity" do
      list = described_class.new
      expect { list.prepend 42 }.to perform_constant.sample(10).times
    end

    it "has O(1) space complexity" do
      list = described_class.new
      expect { list.prepend 42 }.to perform_allocation(3).and_retain(3)
    end
  end

  describe "#each" do
    context "when given a block" do
      it "calls the block for each element" do
        list = described_class.new
        1.upto(3).each { |n| list.prepend n }
        items = list.each.map(&:value)
        expect(items).to eq [3, 2, 1]

        empty_list = described_class.new
        items = empty_list.each.map(&:value)
        expect(items).to eq []
      end

      it "has O(n) time complexity" do
        lists = generate_lists 1, 1_000

        expect { |n, i|
          lists[i].each {}
        }.to perform_linear.in_range(1, 1_000).sample(10).times
      end

      it "has O(1) space complexity" do
        list = described_class.new
        1.upto(1_000).each { list.prepend _1 }

        expect {
          list.each {}
        }.to perform_allocation(1).and_retain(1)
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

    it "has O(n) time complexity" do
      lists = generate_lists 1, 1_000

      expect { |n, i|
        lists[i].length
      }.to perform_linear.in_range(1, 1_000).sample(10).times
    end

    it "has O(1) space complexity" do
      list = described_class.new
      1.upto(1_000).each { list.prepend _1 }

      expect {
        list.length
      }.to perform_allocation(1).and_retain(1)
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
        list.prepend 1

        expect { list[42] }.to raise_error(ArgumentError, "index is too large")
      end
    end

    context "when list is empty" do
      it "errors" do
        list = described_class.new

        expect { list[0] }.to raise_error(ArgumentError, "list is empty")
      end
    end

    context "when index is 0" do
      it "returns the first element" do
        list = described_class.new
        list.prepend 3
        list.prepend 2
        list.prepend 1

        expect(list[0].value).to eq 1
        expect(list.length).to eq 3
      end
    end

    context "when index is the length of the list - 1" do
      it "returns the last element" do
        list = described_class.new
        list.prepend 3
        list.prepend 2
        list.prepend 1

        expect(list[2].value).to eq 3
        expect(list.length).to eq 3
      end
    end

    context "when index is in the middle" do
      it "returns the middle element" do
        list = described_class.new
        list.prepend 3
        list.prepend 2
        list.prepend 1

        expect(list[1].value).to eq 2
        expect(list.length).to eq 3
      end
    end

    it "has O(n) time complexity" do
      lists = generate_lists 1, 1_000

      expect { |n, i|
        list = lists[i]
        list[n - 1] # worst case, accessing the last element
      }.to perform_linear.in_range(1, 1_000).sample(10).times
    end

    it "has O(1) space complexity" do
      list = described_class.new
      1.upto(1_000).each { list.prepend _1 }

      expect {
        list[42]
      }.to perform_allocation(1).and_retain(1)
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
        list.prepend 1
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

        head = list[0]
        tail = head.next

        result = list.delete node: head
        expect(result).to eq head

        expect(list.length).to eq 1
        expect(list[0]).to eq tail
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

        head = list[0]
        tail = list[1]

        result = list.delete node: tail
        expect(result).to eq tail

        expect(list.length).to eq 1
        expect(list[0]).to eq head
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

        head = list[0]
        middle = head.next
        tail = middle.next

        result = list.delete node: middle
        expect(result).to eq middle

        expect(list.length).to eq 2
        expect(list[0]).to eq head
        expect(list[1]).to eq tail
      end
    end

    it "has O(n) time complexity" do
      lists = generate_lists 2, 1_000

      expect { |n, i|
        list = lists[i]
        node = list[n - 1] # worst case, deleting the last element

        list.delete(node:)
      }.to perform_linear.in_range(2, 1_000).sample(1).times
    end

    it "has O(1) space complexity" do
      list = described_class.new
      1.upto(1_000).each { list.prepend _1 }

      expect {
        list[42]
      }.to perform_allocation(1).and_retain(1)
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
        expect(list[0]).to eq result
        expect(list[1].value).to eq 1
        expect(list[2].value).to eq 2
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

    it "has O(n) time complexity" do
      lists = generate_lists 1, 1_000

      expect { |n, i|
        list = lists[i]
        list.insert value: 42, index: n - 1 # worst cast, insert at end
      }.to perform_linear.in_range(1, 1_000).sample(10).times
    end

    it "has O(1) space complexity" do
      list = described_class.new
      1.upto(1_000).each { list.prepend _1 }

      expect {
        list.insert value: 42, index: 42
      }.to perform_allocation(4).and_retain(4)
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

    it "has O(n) time complexity" do
      lists = generate_lists 1, 1_000

      expect { |n, i|
        list = lists[i]
        list.append 42
      }.to perform_linear.in_range(1, 1_000).sample(10).times
    end

    it "has O(1) space complexity" do
      list = described_class.new
      1.upto(1_000).each { list.prepend _1 }

      expect {
        list.append 42
      }.to perform_allocation(3).and_retain(3)
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

    it "has O(n) time complexity" do
      lists = generate_lists 1, 10_000

      expect { |n, i|
        list = lists[i]
        list.include? 500
      }.to perform_linear.in_range(1, 10_000).sample(10).times
    end

    it "has O(1) space complexity" do
      list = described_class.new
      1.upto(1_000).each { list.prepend _1 }

      expect {
        list.include? 42
      }.to perform_allocation(1).and_retain(1)
    end
  end

  describe "#empty?" do
    it "returns whether the list is empty" do
      list = described_class.new
      expect(list.empty?).to be true

      list.append 1
      expect(list.empty?).to be false
    end

    it "has O(1) time complexity" do
      lists = generate_lists 1, 10_000

      expect { |n, i|
        list = lists[i]
        list.empty?
      }.to perform_constant.in_range(1, 10_000).sample(10).times
    end

    it "has O(1) space complexity" do
      list = described_class.new
      1.upto(1_000).each { list.prepend _1 }

      expect { list.empty? }.to perform_allocation(1).and_retain(1)
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
