# frozen_string_literal: true

require 'bundler/setup'
require 'rspec/mocks'
require 'nebius'

# Include RSpec mocks in Cucumber world
World(RSpec::Mocks::ExampleMethods)

# Mock the CLI availability check for all scenarios
Before do
  RSpec::Mocks.setup
  allow(Open3).to receive(:capture3).with('which', 'nebius')
                                    .and_return(['', '', double(success?: true)])
end

After do
  RSpec::Mocks.teardown
end
