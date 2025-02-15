require "simplecov"

SimpleCov.start do
  enable_coverage :branch
  enable_coverage_for_eval

  minimum_coverage 100
end

require "dsa"

RSpec.configure(&:disable_monkey_patching!)
