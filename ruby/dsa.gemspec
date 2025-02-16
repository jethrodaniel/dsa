require_relative "lib/dsa/version"

Gem::Specification.new do |spec|
  spec.name = "dsa"
  spec.version = DSA::VERSION
  spec.authors = ["Mark Delk"]
  spec.email = ["jethrodaniel@gmail.com"]

  spec.required_ruby_version = ">= 3.1.0"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.license = "MIT"

  spec.summary = "Data structures and algorithms"
  spec.files = %w[
    README.md
    LICENSE.txt
    lib/dsa.rb
    lib/dsa/deque.rb
    lib/dsa/doubly_linked_list.rb
    lib/dsa/queue.rb
    lib/dsa/singly_linked_list.rb
    lib/dsa/stack.rb
    lib/dsa/version.rb
  ]
  spec.require_paths = ["lib"]
end
