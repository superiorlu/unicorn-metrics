module UnicornMetrics
  # Timer defined to keep track of total elapsed request time
  # Requires the UnicornMetrics::Middleware
  class RequestTimer < Timer
    attr_reader :path, :method_name

    # @param name [String] user-defined name
    # @param method_name [String] name of the HTTP method
    # @param path [Regex] optional regex that is used to match to a specific URI
    def initialize(name, method_name, path = nil)
      @path        = path
      @method_name = method_name.to_s
      self.class.timers << self
      super(name)
    end

    # @return [Array<UnicornMetrics::RequestTimer>]
    def self.timers
      @timers ||= []
    end

    # @param meth_val [String] is the HTTP method of the request
    # @param path [String] is the URI of the request
    def self.notify(meth_val, path, elapsed_time)
      timers.each { |c| c.tick(elapsed_time) if c.path_method_match?(meth_val, path) }
    end

    # @param (see #notify)
    # @return [Boolean]
    def path_method_match?(meth_val, path_val)
      path_matches?(path_val) && method_matches?(meth_val)
    end

    private

    def path_matches?(val)
      !!(path =~ val) || path.nil?
    end

    def method_matches?(val)
      method_name.upcase == val.to_s
    end
  end
end
