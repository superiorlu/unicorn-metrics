require_relative 'middleware'
module UnicornMetrics
  #:nodoc:
  class Railtie < Rails::Railtie
    initializer 'unicorn_metrics.for_rails_initialization' do |app|
      UnicornMetrics.prefix = Rails.application.class.parent_name.underscore
      app.middleware.use UnicornMetrics::Middleware
    end
  end
end
