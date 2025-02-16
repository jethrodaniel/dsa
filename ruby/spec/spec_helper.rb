require "simplecov"

SimpleCov.start do
  enable_coverage :branch
  enable_coverage_for_eval

  minimum_coverage 100

  add_filter %r{^/spec/}
end

require "dsa"

RSpec.configure(&:disable_monkey_patching!)
