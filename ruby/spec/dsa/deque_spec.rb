RSpec.describe DSA::Deque do
  describe "#push_front" do
    it "pushes an element to the front of the deque" do
      deque = described_class.new
      deque.push_front 1
      deque.push_front 2

      expect(deque.pop_front).to eq 2
      expect(deque.pop_front).to eq 1
    end
  end

  describe "#push_back" do
    it "pushes an element to the back of the deque" do
      deque = described_class.new
      deque.push_back 1
      deque.push_back 2

      expect(deque.pop_back).to eq 2
      expect(deque.pop_back).to eq 1
    end
  end

  describe "#pop_front" do
    context "when empty" do
      it "errors" do
        deque = described_class.new
        expect { deque.pop_front }.to raise_error(ArgumentError, "deque must not be empty")
      end
    end

    context "when not empty" do
      it "pops an element from the front of the deque" do
        deque = described_class.new
        deque.push_front 1
        deque.push_front 2

        expect(deque.pop_front).to eq 2
        expect(deque.pop_front).to eq 1
      end
    end
  end

  describe "#pop_back" do
    context "when empty" do
      it "errors" do
        deque = described_class.new
        expect { deque.pop_back }.to raise_error(ArgumentError, "deque must not be empty")
      end
    end

    context "when not empty" do
      it "pops an element from the back of the deque" do
        deque = described_class.new
        deque.push_back 1
        deque.push_back 2

        expect(deque.pop_back).to eq 2
        expect(deque.pop_back).to eq 1
      end
    end
  end

  describe "#peek_front" do
    context "when empty" do
      it "errors" do
        deque = described_class.new
        expect { deque.peek_front }.to raise_error(ArgumentError, "deque must not be empty")
      end
    end

    context "when not empty" do
      it "returns the front of the deque" do
        deque = described_class.new
        deque.push_front 1
        deque.push_front 2

        expect(deque.peek_front).to eq 2
        expect(deque.peek_front).to eq 2
      end
    end
  end

  describe "#peek_back" do
    context "when empty" do
      it "errors" do
        deque = described_class.new
        expect { deque.peek_back }.to raise_error(ArgumentError, "deque must not be empty")
      end
    end

    context "when not empty" do
      it "returns the back of the deque" do
        deque = described_class.new
        deque.push_back 1
        deque.push_back 2

        expect(deque.peek_back).to eq 2
        expect(deque.peek_back).to eq 2
      end
    end
  end

  describe "#empty?" do
    context "when empty" do
      it "returns true" do
        deque = described_class.new
        expect(deque.empty?).to be true
      end
    end

    context "when not empty" do
      it "returns false" do
        deque = described_class.new
        expect(deque.empty?).to be true

        deque.push_front 1
        expect(deque.empty?).to be false

        deque.pop_front
        expect(deque.empty?).to be true
      end
    end
  end

  describe "#length" do
    it "returns the number of items in the deque" do
      deque = described_class.new

      expect(deque.length).to eq 0
      deque.push_front 1
      expect(deque.length).to eq 1
      deque.push_front 2
      expect(deque.length).to eq 2
      deque.pop_front
      expect(deque.length).to eq 1
      deque.pop_front
      expect(deque.length).to eq 0

      deque.push_back 1
      expect(deque.length).to eq 1
      deque.push_back 2
      expect(deque.length).to eq 2
      deque.pop_back
      expect(deque.length).to eq 1
      deque.pop_back
      expect(deque.length).to eq 0
    end
  end

  describe "#to_s" do
    it "prints the deque" do
      deque = described_class.new
      deque.push_back 2
      deque.push_back 3
      deque.push_front 1

      expect(deque.to_s).to eq "(front) 1, 2, 3 (back)"
    end
  end
end
