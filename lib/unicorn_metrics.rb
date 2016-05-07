#:nodoc:
module UnicornMetrics
  class << self
    attr_writer :http_metrics # Enable/disable HTTP metrics. Includes defaults
    attr_accessor :app_name # display metric by app name

    # Returns the UnicornMetrics::Registry object
    #
    # @return [UnicornMetrics::Registry]
    def registry
      UnicornMetrics::Registry
    end

    # Make this class 'configurable'
    #
    # @yieldparam self [UnicornMetrics]
    def configure
      yield self
    end

    def app_name
      @app_name || 'app'
    end

    # regsiger default component
    def default_register
      registry.register(:cloudinsight, 'cloudinsight')
      register_default_http_metric if http_metrics?
    end

    def register_default_http_metric
      registry.extend(UnicornMetrics::DefaultHttpMetrics)
      registry.register_default_http_counters
      registry.register_default_http_timers
    end

    def http_metrics
      @http_metrics.nil? ? true : @http_metrics
    end

    # Used by the middleware to determine whether any HTTP metrics have been defined
    #
    # @return [Boolean] if HTTP metrics have been defined
    def http_metrics?
      http_metrics
    end

    private

    # Delegate methods to UnicornMetrics::Registry
    #
    # http://robots.thoughtbot.com/post/28335346416/always-define-respond-to-missing-when-overriding
    def respond_to_missing?(method_name, include_private = false)
      registry.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &block)
      return super unless registry.respond_to?(method_name)
      registry.send(method_name, *args, &block)
    end
  end
end

require 'raindrops'
require 'cloudinsight-sdk'
require 'unicorn_metrics/registry'
require 'unicorn_metrics/version'
require 'unicorn_metrics/counter'
require 'unicorn_metrics/timer'
require 'unicorn_metrics/default_http_metrics'
require 'unicorn_metrics/request_counter'
require 'unicorn_metrics/request_timer'
require 'unicorn_metrics/response_counter'
require 'unicorn_metrics/response_counter'
require 'unicorn_metrics/cloudinsight'
require 'unicorn_metrics/railtie' if defined?(::Rails)
require 'forwardable'
