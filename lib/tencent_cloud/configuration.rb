# frozen_string_literal: true

require 'singleton'

module TencentCloud
  class Configuration
    include Singleton
    attr_reader :secret_id, :secret_key, :host, :region, :bucket

    def self.init(config)
      @ready = true
      instance.vars(config)
    end

    def vars(config)
      config.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

    def is_ready?
      @ready
    end
  end
end
