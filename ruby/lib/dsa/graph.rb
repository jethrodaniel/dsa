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
    end

    attr_reader :adjacency_list

    def add_vertex value:
      vertex = Vertex.new(value:)
      @adjacency_list[vertex] = SinglyLinkedList.new
      vertex
    end

    def add_edge from:, to:
      # TODO: ensure vertices are already present in the graph
      @adjacency_list.fetch(from).prepend(to)
    end

    # Kahn’s algorithm
    #
    # - Time: O(V + E)
    # - Space: O(V)
    #
    def topological_sort
      sources = DSA::Queue.new
      in_degrees = {}
      result = []

      @adjacency_list.each do |vertex, edges|
        in_degrees[vertex] ||= 0

        edges.each do |dest_node|
          destination_vertex = dest_node.value

          in_degrees[destination_vertex] ||= 0
          in_degrees[destination_vertex] += 1
        end
      end

      in_degrees.select { |k, v| v.zero? }.each do |source, _edges|
        sources.enqueue source
      end

      until sources.empty?
        source = sources.dequeue
        result << source

        outgoing_edges = @adjacency_list[source]

        outgoing_edges.each do |node|
          vertex = node.value

          in_degrees[vertex] -= 1

          sources.enqueue(vertex) if in_degrees[vertex].zero?
        end
      end

      if result.size < @adjacency_list.keys.size
        raise ArgumentError, "graph cannot contain cycles"
      end

      result
    end
  end
end
