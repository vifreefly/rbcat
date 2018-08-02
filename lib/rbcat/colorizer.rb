module Rbcat
  class Colorizer
    def self.print_colors
      Rbcat::Colors::DEFAULT.each do |key, value|
        puts "#{value}#{key}\e[0m"
      end
    end

    def self.colorize(string, predefined: nil, rules: nil, order: nil)
      return string if ENV["RBCAT_COLORIZER"] == "false"

      colors = Rbcat::Colors::DEFAULT
      config = create_config(predefined, rules, order)

      config.each_value do |settings|
        if settings[:once]
          string.sub!(settings[:regexp]) do |match|
            colors[settings[:color]] + match + colors[:default]
          end
        elsif settings[:colors]
          string.gsub!(settings[:regexp]) do
            str = ""
            Regexp.last_match.captures.each_with_index do |match, i|
              str << colors[settings[:colors][i]] + match + colors[:default]
            end

            str
          end
        else
          string.gsub!(settings[:regexp]) do |match|
            colors[settings[:color]] + match + colors[:default]
          end
        end
      end

      string
    end

    def self.uncolorize(string)
      pattern = /\033\[([0-9]+);([0-9]+)m|\033\[([0-9]+)m/m
      string.gsub(pattern, "")
    end

    private_class_method def self.create_config(predefined, rules, order)
      predefined_rules = predefined ? predefined : Rbcat.configuration&.predefined
      rules ||= Rbcat.configuration&.rules

      raise ConfigurationError, "No config defined." unless predefined_rules || rules
      if rules && rules.class != Hash
        raise ConfigurationError, "Incorrect configuration. " \
          "There is error while converting yaml config into Ruby's hash of rules."
      end

      config = {}
      order ||= Rbcat.configuration&.order || :predefined_first

      case order
      when :predefined_first
        predefined_rules&.each do |group|
          config.merge!(Object.const_get "Rbcat::Rules::#{group.to_s.upcase}")
        end

        rules ? deep_merge(config, rules) : config
      when :predefined_last
        config.merge!(rules) if rules

        predefined_rules&.each do |group|
          config.merge!(Object.const_get "Rbcat::Rules::#{group.to_s.upcase}")
        end

        config
      else
        raise ConfigurationError, "Wrong type of order: #{order}. " \
          "Define :predefined_first (default) or :predefined_last"
      end
    end

    private_class_method def self.deep_merge(hash, other_hash)
      other_hash.each_pair do |current_key, other_value|
        this_value = hash[current_key]
        hash[current_key] =
          if this_value.is_a?(Hash) && other_value.is_a?(Hash)
            deep_merge(this_value, other_value)
          else
            other_value
          end
      end

      hash
    end
  end
end
