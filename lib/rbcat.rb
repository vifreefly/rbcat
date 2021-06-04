require "rbcat/version"
require "rbcat/configuration"
require "rbcat/colors"
require "rbcat/rules"
require "rbcat/colorizer"
require "rbcat/cli"

module Rbcat
  def self.colorize(string, options = {})
    Colorizer.colorize(string, **options)
  end
end
