RSpec.describe DSA::ArrayList do
  describe "#initialize" do
    it "errors if capacity is invalid" do
      expect { described_class.new capacity: 0 }
        .to raise_error(ArgumentError, "capacity must be positive")
      expect { described_class.new capacity: -1 }
        .to raise_error(ArgumentError, "capacity must be positive")
    end
  end

  describe "#capacity" do
    it "has a default capacity" do
      list = described_class.new
      expect(list.capacity).to eq 100
    end

    it "has an intial capacity" do
      list = described_class.new capacity: 42
      expect(list.capacity).to eq 42
    end
  end

  describe "#length" do
    it "returns the number of items in the list" do
      list = described_class.new
      expect(list.length).to eq 0

      list[0] = 42
      expect(list.length).to eq 1
    end
  end

  describe "#[]" do
    context "when index is invalid" do
      it "errors" do
        list = described_class.new
        expect { list[-1] }.to raise_error(ArgumentError, "index must be >= 0")
      end
    end

    context "when index is less than the length" do
      it "returns the item at that index" do
        list = described_class.new
        list[0] = 42
        expect(list[0]).to eq 42
      end
    end

    context "when index is greater than or equal to the length" do
      it "errors" do
        list = described_class.new
        list[0] = 42
        expect { list[1] }.to raise_error(ArgumentError, "index out of bounds")
      end
    end
  end

  describe "#[]=" do
    context "when index is invalid" do
      it "errors" do
        list = described_class.new
        expect { list[-1] = 42 }.to raise_error(ArgumentError, "index must be >= 0")
      end
    end

    context "when index is less than the capacity" do
      it "sets the item at that index" do
        list = described_class.new
        list[0] = 42
        expect(list[0]).to eq 42
      end
    end

    context "when index is greater than or equal to the capacity" do
      it "resizes the array and sets the item at that index" do
        skip "TODO"
      end
    end
  end

  describe "#append" do
    it "adds an item to the end of the list" do
      list = described_class.new
      list[0] = 1
      list[1] = 2
      list.append 42

      expect(list[2]).to eq 42
      expect(list.length).to eq 3
    end
  end
end
