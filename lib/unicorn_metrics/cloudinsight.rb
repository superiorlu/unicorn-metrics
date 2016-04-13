module UnicornMetrics
  #:nodoc:
  class Cloudinsight
    attr_reader :statsd, :name

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
        ci.collect(registry.as_json.merge(raindrops))
      end
    end

    def collect(metrics_data)
      metrics_data.each do |metric, info|
        next if filter?(info[:type])
        metric_name = "#{UnicornMetrics.prefix}.#{metric}.#{info[:type]}"
        statsd.gauge("#{metric_name}.sum", info[:sum]) if timer?(info[:type])
        statsd.gauge(metric_name, info[:value])
      end
    end

    def filter?(metric_type)
      metric_type == type
    end

    def timer?(metric_type)
      metric_type == 'timer'
    end

    def type
      'collector'
    end

    def as_json
      {
        name.to_sym => {
          type: type,
          status: 'running'
        }

      }
    end
  end
end
