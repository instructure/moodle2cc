#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.libs.push "test"
  t.pattern = "test/**/*_test.rb"

  # setting to true shows ruby interpreter warnings
  t.warning = false
  t.verbose = false
end

RSpec::Core::RakeTask.new(:spec)

task :all_tests => [:test, :spec]

task :default => :all_tests
