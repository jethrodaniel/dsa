RSpec.describe DSA::Stack do
  describe "#push" do
    it "pushes an element to the top of the stack" do
      stack = described_class.new
      stack.push 1
      stack.push 2

      expect(stack.pop).to eq 2
      expect(stack.pop).to eq 1
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

        expect(stack.pop).to eq 1
      end
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
