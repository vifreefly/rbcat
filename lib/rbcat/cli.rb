# frozen_string_literal: true

require 'optparse'
require 'yaml'

module Rbcat
  class CLI
    def self.start(args)
      options = parse_options(args)
      colorizer_options = create_colorizer_options(options)

      while input = STDIN.gets
        input.each_line do |line|
          begin
            puts Rbcat.colorize(line, colorizer_options)
          rescue Errno::EPIPE
            exit(74)
          end
        end
      end
    end

    private_class_method def self.create_colorizer_options(options)
      rules =
        if options[:rules]
          file_path = File.expand_path(options[:rules])
          unless File.exist? file_path
            raise ConfigurationError, "Config file not found: #{file_path}."
          else
            YAML.load_file(file_path)
          end
        end

      predefined = options[:predefined]
      order = options[:order]

      { predefined: predefined, rules: rules, order: order }
    end

    private_class_method def self.parse_options(args)
      options = {}

      args.push("-h") if args.empty?

      OptionParser.new do |opts|
        opts.banner = <<~HEREDOC
          Rbcat it's a CLI tool which reads from standard input (STDIN),
          colorizes content by set of regex rules from a config file,
          and then writes it to standard output.
        HEREDOC
        opts.separator ""

        predefined_desc = "Colorize input by set of predefined rules. " \
          "Currently there are json/hash 'jsonhash' and ruby's logger 'logger'. " \
          "Example: --predefined=jsonhash,logger"
        opts.on("-p", "--predefined GROUPS", Array, predefined_desc) do |arg|
          options[:predefined] = arg
        end

        rules_desc = "Path to the custom yaml config for rbcat."
        opts.on("-r", "--rules PATH", rules_desc) do |arg|
          options[:rules] = arg
        end

        order_desc = "Specify order for predefined and custom rules." \
          "Avaiable options: 'predefined_first' (default) or 'predefined_last'."
        opts.on("-o", "--order ORDER", order_desc) do |arg|
          options[:order] = arg
        end

        opts.on("-c", "--print_colors", "Print all avaiable colors.") do
          Rbcat::Colorizer.print_colors
          exit
        end

        opts.on_tail("-v", "--version", "Show version") do
          puts Rbcat::VERSION
          exit
        end
      end.parse!(args)

      options
    end
  end
end
