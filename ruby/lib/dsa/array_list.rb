module DSA
  # An array list (a growable array).
  #
  class ArrayList
    # @return [Integer]
    attr_reader :capacity

    # @return [Integer]
    attr_reader :length

    # @param capacity [Integer]
    def initialize capacity: 100
      raise ArgumentError, "capacity must be positive" unless capacity.positive?

      @capacity = capacity
      @length = 0
      @array = Array.new(capacity) { nil }
    end

    # @param index [Integer]
    # @return [T]
    #
    def [] index
      raise ArgumentError, "index must be >= 0" if index.negative?

      raise ArgumentError, "index out of bounds" if index > @length - 1

      @length = index + 1 if index + 1 > @length

      @array[index]
    end

    # @param index [Integer]
    # @param item [T]
    # @return [T]
    #
    def []= index, item
      raise ArgumentError, "index must be >= 0" if index.negative?

      raise ArgumentError, "TODO" if index > @capacity

      @length = index + 1 if index + 1 > @length

      @array[index] = item
    end

    # @param item [T]
    # @return [T]
    #
    def append item
      @array[@length] = item
      @length += 1
      item
    end
  end
end
