RSpec.describe DSA do
  describe "::VERSION" do
    subject { described_class::VERSION }

    it { is_expected.to eq("0.0.0") }
  end

  it "has the correct gemspec info" do
    path = File.expand_path("../../dsa.gemspec", __FILE__)
    gemspec = Gem::Specification.load path

    expect(gemspec).to have_attributes(
      name: "dsa",
      version: Gem::Version.new("0.0.0"),
      files: [
        "LICENSE.txt",
        "README.md",
        "lib/dsa.rb",
        "lib/dsa/array_list.rb",
        "lib/dsa/binary_tree.rb",
        "lib/dsa/deque.rb",
        "lib/dsa/doubly_linked_list.rb",
        "lib/dsa/queue.rb",
        "lib/dsa/singly_linked_list.rb",
        "lib/dsa/stack.rb",
        "lib/dsa/trie.rb",
        "lib/dsa/version.rb"
      ],
      licenses: ["MIT"],
      metadata: {"rubygems_mfa_required" => "true"},
      require_paths: ["lib"],
      required_ruby_version: Gem::Requirement.new([">= 3.1.0"]),
      summary: "Data structures and algorithms"
    )
  end
end
