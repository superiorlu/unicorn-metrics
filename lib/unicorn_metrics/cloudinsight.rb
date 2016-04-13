module UnicornMetrics
  #:nodoc:
  class Cloudinsight
    attr_reader :statsd, :name, :metrics_data
    def initialize(name)
      @name = name || 'cloudinsight'
      @statsd = OneapmCi::Statsd.new
      self.class.cloudinsights << self
    end

    def self.cloudinsights
      @cloudinsights ||= []
    end

    def self.notify(registry, raindrops)
      cloudinsights.each do |ci|
        ci.metrics_data = registry.as_json.merge(raindrops)
        ci.collect_data
      end
    end

    def collect_data
      metrics_data.each do |metric, value|
        puts "metric: #{metric} value:#{value}"
      end
    end

    def type
      'collector'
    end

    def as_json
      {
        name => {
          type: type,
          data: metrics_data.size
        }

      }
    end
  end
end
