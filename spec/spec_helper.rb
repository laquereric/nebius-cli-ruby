# frozen_string_literal: true

require 'bundler/setup'
require 'nebius'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on Module and main
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Mock external CLI calls by default
  config.before(:each) do
    allow(Open3).to receive(:capture3).and_return(['{}', '', double(success?: true, exitstatus: 0)])
  end
end
