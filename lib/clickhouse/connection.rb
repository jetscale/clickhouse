require "clickhouse/connection/client"
require "clickhouse/connection/logger"
require "clickhouse/connection/query"

module Clickhouse
  class Connection

    DEFAULT_CONFIG = {
      :scheme => "http",
      :host => "localhost",
      :port => 8123
    }

    include Client
    include Logger
    include Query

    def initialize(config = {})
      @config = normalize_config(config)
    end

  private

    def normalize_config(config)
      config = config.inject({}) do |hash, (key, value)|
        hash[key.to_sym] = value
        hash
      end

      if config[:url]
        uri = URI Clickhouse::Utils.normalize_url(config[:url])
        config[:scheme] = uri.scheme
        config[:host] = uri.host
        config[:port] = uri.port
        config.delete(:url)
      end

      DEFAULT_CONFIG.merge(config.reject{|_k, v| v.nil?})
    end

  end
end
