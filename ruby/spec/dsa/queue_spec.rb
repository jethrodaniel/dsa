RSpec.describe DSA::Queue do
  describe "#enqueue" do
    it "pushes an element to the back of the queue" do
      queue = described_class.new
      queue.enqueue 1
      queue.enqueue 2

      expect(queue.dequeue).to eq 1
      expect(queue.dequeue).to eq 2
    end
  end

  describe "#dequeue" do
    context "when empty" do
      it "errors" do
        queue = described_class.new
        expect { queue.dequeue }.to raise_error(ArgumentError, "queue must not be empty")
      end
    end

    context "when not empty" do
      it "pops an element from the front of the queue" do
        queue = described_class.new
        queue.enqueue 1

        expect(queue.dequeue).to eq 1
      end
    end
  end

  describe "#peek" do
    context "when empty" do
      it "errors" do
        queue = described_class.new
        expect { queue.peek }.to raise_error(ArgumentError, "queue must not be empty")
      end
    end

    context "when not empty" do
      it "returns the front of the queue" do
        queue = described_class.new
        queue.enqueue 1

        expect(queue.peek).to eq 1
        expect(queue.peek).to eq 1
      end
    end
  end

  describe "#empty?" do
    context "when empty" do
      it "returns true" do
        queue = described_class.new
        expect(queue.empty?).to be true
      end
    end

    context "when not empty" do
      it "returns false" do
        queue = described_class.new
        expect(queue.empty?).to be true

        queue.enqueue 1
        expect(queue.empty?).to be false

        queue.dequeue
        expect(queue.empty?).to be true
      end
    end
  end

  describe "#length" do
    it "returns the number of items in the queue" do
      queue = described_class.new

      expect(queue.length).to eq 0
      queue.enqueue 1
      expect(queue.length).to eq 1
      queue.enqueue 2
      expect(queue.length).to eq 2
      queue.dequeue
      expect(queue.length).to eq 1
      queue.dequeue
      expect(queue.length).to eq 0
    end
  end

  describe "#to_s" do
    it "prints the queue" do
      queue = described_class.new
      queue.enqueue 1
      queue.enqueue 2
      queue.enqueue 3

      expect(queue.to_s).to eq "(front) 1, 2, 3 (back)"
    end
  end
end
