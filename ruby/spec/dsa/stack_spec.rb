RSpec.describe DSA::Stack do
  def generate_stacks from, to
    bench_range(from, to).map do |n|
      stack = described_class.new
      1.upto(n).each { stack.push _1 }
      stack
    end
  end

  describe "#push" do
    it "pushes an element to the top of the stack" do
      stack = described_class.new

      expect(stack.push(1)).to eq(1)
      expect(stack.push(2)).to eq(2)

      expect(stack.pop).to eq 2
      expect(stack.pop).to eq 1
    end

    it "has O(1) time complexity" do
      stacks = generate_stacks 1, 1_000
      expect { |n, i| stacks[i].push 42 }.to perform_constant
    end

    it "has O(1) space complexity" do
      stack = described_class.new
      expect { stack.push 42 }.to perform_allocation(3).and_retain(3)
    end
  end

  describe "#pop" do
    context "when empty" do
      it "errors" do
        stack = described_class.new
        expect { stack.pop }.to raise_error(ArgumentError, "stack must not be empty")
      end
    end

    context "when not empty" do
      it "pops an element from the top of the stack" do
        stack = described_class.new
        stack.push 1
        stack.push 2

        expect(stack.pop).to eq 2
        expect(stack.pop).to eq 1
      end
    end

    it "has O(1) time complexity" do
      stacks = generate_stacks 10, 1_000
      expect { |_, i| stacks[i].pop }.to perform_constant.in_range(10, 1_000)
    end

    it "has O(1) space complexity" do
      stack = generate_stacks(1, 1).first
      expect { stack.push 42 }.to perform_allocation(3).and_retain(3)
    end
  end

  describe "#peek" do
    context "when empty" do
      it "errors" do
        stack = described_class.new
        expect { stack.peek }.to raise_error(ArgumentError, "stack must not be empty")
      end
    end

    context "when not empty" do
      it "returns the top of the stack" do
        stack = described_class.new
        stack.push 1

        expect(stack.peek).to eq 1
        expect(stack.peek).to eq 1
      end
    end

    it "has O(1) time complexity" do
      stacks = generate_stacks 1, 1_000
      expect { |_, i| stacks[i].peek }.to perform_constant
    end

    it "has O(1) space complexity" do
      stack = generate_stacks(1, 1).first
      expect { stack.push 42 }.to perform_allocation(3).and_retain(3)
    end
  end

  describe "#empty?" do
    context "when empty" do
      it "returns true" do
        stack = described_class.new
        expect(stack.empty?).to be true
      end
    end

    context "when not empty" do
      it "returns false" do
        stack = described_class.new
        expect(stack.empty?).to be true

        stack.push 1
        expect(stack.empty?).to be false

        stack.pop
        expect(stack.empty?).to be true
      end
    end

    it "has O(1) time complexity" do
      stacks = generate_stacks 1, 1_000
      expect { |_, i| stacks[i].empty? }.to perform_constant
    end

    it "has O(1) space complexity" do
      stack = generate_stacks(1, 1).first
      expect { stack.empty? }.to perform_allocation(0)
    end
  end

  describe "#length" do
    it "returns the number of items in the stack" do
      stack = described_class.new

      expect(stack.length).to eq 0
      stack.push 1
      expect(stack.length).to eq 1
      stack.push 2
      expect(stack.length).to eq 2
      stack.pop
      expect(stack.length).to eq 1
      stack.pop
      expect(stack.length).to eq 0
    end

    it "has O(n) time complexity" do
      stacks = generate_stacks 1, 1_000
      expect { |_, i| stacks[i].length }.to perform_linear.in_range(1, 1_000)
    end

    it "has O(1) space complexity" do
      stack = described_class.new
      1.upto(1_000).each { stack.push _1 }
      expect { stack.length }.to perform_allocation(1).and_retain(1)
    end
  end

  describe "#to_s" do
    it "prints the stack" do
      stack = described_class.new
      stack.push 1
      stack.push 2
      stack.push 3

      expect(stack.to_s).to eq "(bottom) 1, 2, 3 (top)"
    end
  end
end
