module Foodtaster
  class Config
    %w(log_level drb_port vagrant_binary shutdown_vms
       skip_rollback).each do |attr|
      attr_accessor attr.to_sym
    end

    def initialize
      @log_level = :info
      @drb_port = 35672
      @vagrant_binary = 'vagrant'
      @shutdown_vms = false
      @skip_rollback = false
    end

    def self.default
      self.new
    end
  end

  class << self
    def config
      @config ||= Config.default
    end

    def configure
      if block_given?
        yield(self.config)
      else
        raise ArgumentError, "No block given"
      end
    end
  end
end
