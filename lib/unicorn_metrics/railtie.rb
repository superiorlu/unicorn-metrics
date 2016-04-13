module Rack
  module QueueMetrics
    #:nodoc:
    class RackQueueRailtie < Rails::Railtie
      initializer 'unicorn_metrics.for_rails_initialization' do |app|
        app.middleware.use UnicornMetrics::Middleware
      end
    end
  end
end
