#:nodoc:
module UnicornMetrics
  class << self
    attr_accessor :http_metrics # Enable/disable HTTP metrics. Includes defaults

    @http_metrics = true

    # attr_accessor assigned
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

    # egsiger default component
    def default_register
      registry.register(:cloudinsight, 'cloudinsight')
      register_default_http_metric
    end

    def register_default_http_metric
      return unless http_metrics?
      registry.extend(UnicornMetrics::DefaultHttpMetrics)
      registry.register_default_http_counters
      registry.register_default_http_timers
    end

    # Used by the middleware to determine whether any HTTP metrics have been defined
    #
    # @return [Boolean] if HTTP metrics have been defined
    def http_metrics?
      http_metrics
    end

    def reset
      registry.reset
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
require 'oneapm_ci'
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