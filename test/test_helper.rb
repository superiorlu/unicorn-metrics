require 'pry'
require 'minitest/spec'
require 'minitest/autorun'
require 'unicorn_metrics'
require 'mocha/mini_test'

alias context describe

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new
