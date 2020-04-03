# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'rake/testtask'

Rake::TestTask.new(:test) do |task|
  task.libs << 'test'
  task.pattern = 'test/**/*_test.rb'
end

task default: :test
