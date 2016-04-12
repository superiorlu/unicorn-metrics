# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unicorn_metrics/version'

Gem::Specification.new do |spec|
  spec.name          = 'unicorn_metrics'
  spec.version       = UnicornMetrics::VERSION
  spec.authors       = ['Alan Cohen']
  spec.email         = ['acohen@climate.com']
  spec.summary       = 'Metrics library for Rack applications using a preforking http server (i.e., Unicorn) '
  spec.homepage      = 'http://www.climate.com'
  spec.files         = Dir['lib/**/*.rb'] + Dir['test/*']
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency('rake', '~> 10.1.0')
  spec.add_development_dependency('minitest', '~> 5.8.4')
  spec.add_development_dependency('minitest-reporters', '~> 1.1.8')
  spec.add_development_dependency('guard', '~> 2.13.0')
  spec.add_development_dependency('guard-minitest', '~> 2.4.4')
  spec.add_development_dependency('mocha', '~> 1.1.0')
  spec.add_development_dependency('rubocop', '~> 0.39.0')
  spec.add_development_dependency('pry', '~> 0.10.3')

  spec.add_dependency('raindrops', '~> 0.16.0')
  spec.add_dependency('oneapm_ci', '~> 0.0.1')
  spec.requirements << 'Preforking http server (i.e., Unicorn).'
  spec.required_ruby_version = '>= 1.9.3'
end
