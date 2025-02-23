require "simplecov"

SimpleCov.start do
  enable_coverage :branch
  enable_coverage_for_eval

  minimum_coverage 100

  add_filter %r{^/spec/}
end

require "rspec-benchmark"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.include RSpec::Benchmark::Matchers
end

require "dsa"
