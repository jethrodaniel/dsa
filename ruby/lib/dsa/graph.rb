module DSA
  # A graph, implemented as an adjacency list.
  #
  class Graph
    class Vertex
      # @return [T]
      attr_accessor :value

      # @param value [T]
      def initialize value:
        @value = value
      end
    end

    def initialize
      @adjacency_list = {}
      @in_degrees = {}
    end

    attr_reader :adjacency_list

    def add_vertex value:
      vertex = Vertex.new(value:)
      @adjacency_list[vertex] = SinglyLinkedList.new
      @in_degrees[vertex] ||= 0
      vertex
    end

    def add_edge from:, to:
      # TODO: ensure vertices are already present in the graph
      @adjacency_list.fetch(from).prepend(to)
      @in_degrees[to] += 1
    end

    # Kahn’s algorithm
    #
    # - Time: O(V + E)
    # - Space: O(V)
    #
    def topological_sort
      sources = DSA::Queue.new
      result = []

      @in_degrees.select { |k, v| v.zero? }.keys.each do |source|
        sources.enqueue source
      end

      until sources.empty?
        source = sources.dequeue
        result << source

        children = @adjacency_list[source]

        children.each do |node|
          child = node.value

          @in_degrees[child] -= 1

          if @in_degrees[child].zero?
            sources.enqueue child
          end
        end
      end

      if result.size < @adjacency_list.keys.size
        raise ArgumentError, "graph cannot contain cycles"
      end

      result
    end
  end
end
