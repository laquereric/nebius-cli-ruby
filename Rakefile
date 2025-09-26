# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:cucumber) do |task|
  task.cucumber_opts = '--format pretty'
end

task default: %i[spec cucumber]

desc 'Run RuboCop'
task :rubocop do
  sh 'rubocop'
end

desc 'Generate documentation'
task :doc do
  sh 'yard doc'
end

desc 'Run all checks (tests, linting, documentation)'
task check: %i[spec cucumber rubocop doc]
