RSpec.describe DSA::Graph do
  describe "#add_vertex" do
    it "creates a new vertex" do
      graph = described_class.new

      vertex = graph.add_vertex(value: 42)

      expect(vertex).to be_a described_class::Vertex
      expect(vertex.value).to eq 42
    end
  end

  describe "#add_edge" do
    it "creates a new edge" do
      graph = described_class.new

      one = graph.add_vertex(value: 1)
      two = graph.add_vertex(value: 2)

      graph.add_edge(from: one, to: two)

      edges = graph.adjacency_list[one]
      expect(edges).to be_a DSA::SinglyLinkedList
      expect(edges.length).to eq 1
      expect(edges[0].value).to be_a described_class::Vertex
      expect(edges[0].value.value).to eq 2
    end
  end

  describe "#topological_sort" do
    it "returns a sorted list of vertices" do
      graph = described_class.new

      cook_veggies = graph.add_vertex(value: :cook_veggies)
      cook_meat = graph.add_vertex(value: :cook_meat)
      prep_veggies = graph.add_vertex(value: :prep_veggies)
      prep_meat = graph.add_vertex(value: :prep_meat)
      cook_rice = graph.add_vertex(value: :cook_rice)
      serve_meal = graph.add_vertex(value: :serve_meal)
      buy_food = graph.add_vertex(value: :buy_food)

      graph.add_edge(from: buy_food, to: prep_veggies)
      graph.add_edge(from: buy_food, to: prep_meat)
      graph.add_edge(from: buy_food, to: cook_rice)

      graph.add_edge(from: prep_veggies, to: cook_veggies)
      graph.add_edge(from: prep_meat, to: cook_meat)

      graph.add_edge(from: cook_veggies, to: serve_meal)
      graph.add_edge(from: cook_meat, to: serve_meal)
      graph.add_edge(from: cook_rice, to: serve_meal)

      result = graph.topological_sort

      expect(result).to be_a Array
      expect(result[0]).to eq buy_food
      expect(result[1]).to eq cook_rice
      expect(result[2]).to eq prep_meat
      expect(result[3]).to eq prep_veggies
      expect(result[4]).to eq cook_meat
      expect(result[5]).to eq cook_veggies
      expect(result[6]).to eq serve_meal
    end

    it "errors if graph contains a cycle" do
      graph = described_class.new

      one = graph.add_vertex(value: 1)
      two = graph.add_vertex(value: 2)
      three = graph.add_vertex(value: 3)

      graph.add_edge(from: one, to: two)
      graph.add_edge(from: two, to: three)
      graph.add_edge(from: three, to: one)

      expect { graph.topological_sort }
        .to raise_error(ArgumentError, "graph cannot contain cycles")
    end
  end
end
