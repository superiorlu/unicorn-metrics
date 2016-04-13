require_relative 'middleware'
module UnicornMetrics
  #:nodoc:
  class Railtie < Rails::Railtie
    initializer 'unicorn_metrics.for_rails_initialization' do |app|
      app.middleware.use UnicornMetrics::Middleware
      UnicornMetrics.default_register
    end
  end
end
