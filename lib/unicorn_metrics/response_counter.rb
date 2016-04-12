module UnicornMetrics
  # Counter defined to keep count of status codes of http responses
  # Requires the UnicornMetrics::Middleware
  class ResponseCounter < Counter
    attr_reader :path, :status_code

    # @param name [String] user-defined name
    # @param status_code [Regex] the HTTP status code (e.g., `/[2]\d{2}/`)
    # @param path [Regex] optional regex that is used to match to a specific URI
    def initialize(name, status_code, path = nil)
      @path        = path
      @status_code = status_code
      self.class.counters << self
      super(name)
    end

    # @return [Array<UnicornMetrics::ResponseCounter>]
    def self.counters
      @status_counters ||= []
    end

    # @param status [String] is the HTTP status code of the request
    # @param path [String] is the URI of the request
    def self.notify(status, path)
      counters.each { |c| c.increment if c.path_status_match?(status, path) }
    end

    # @param (see #notify)
    # @return [Boolean]
    def path_status_match?(status, path)
      status_matches?(status) && path_matches?(path)
    end

    private

    def path_matches?(val)
      path.nil? || !!(path =~ val)
    end

    def status_matches?(val)
      !!(status_code =~ val.to_s)
    end
  end
end