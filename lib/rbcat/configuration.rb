module Rbcat
  class ConfigurationError < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :predefined, :rules, :order

    def initialize
      @predefined = nil
      @rules = nil
      @order = nil
    end
  end
end
