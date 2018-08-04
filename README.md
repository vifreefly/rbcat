# Rbcat

### Introduction

Rbcat it's a CLI tool written in ruby which reads from standard input (STDIN), colorizes content by set of regex rules from a config file, and then writes it to standard output. Inspired by [grcat](https://github.com/garabik/grc).
You can use rbcat in your ruby/ROR projects or as a standalone CLI tool (similar to grcat).

**Install rbcat first:** `gem install rbcat`

```ruby
# rbcat_example.rb

description = <<~HEREDOC
  Rbcat it's a CLI tool written in ruby which reads from standard input (stdin),
  colorizes content by set of regex rules from a config file, and then writes it
  to standard output.
  You can use rbcat in your ruby/ROR projects or as a standalone CLI tool (similar to grcat).
HEREDOC

rules = {
  ruby_word: {
    regexp: /ruby/m,
    color: :red
  },
  upcase_words: {
    regexp: /[A-Z]{2,}/m,
    color: :bold
  },
  inside_round_brackets: {
    regexp: /\(.*?\)/m,
    color: :cyan
  },
  gem_name: {
    regexp: /rbcat/mi,
    color: :green
  }
}

require "rbcat"
puts Rbcat.colorize(description, rules: rules)
```

![](https://hsto.org/webt/qp/pp/nb/qpppnbvennx7yp5nxpye5qrgt_c.png)


**Same using CLI:**
```yaml
# rbcat_config.yaml
---
:ruby_word:
  :regexp: !ruby/regexp /ruby/m
  :color: :red
:upcase_words:
  :regexp: !ruby/regexp /[A-Z]{2,}/m
  :color: :bold
:inside_round_brackets:
  :regexp: !ruby/regexp /\(.*?\)/m
  :color: :cyan
:gem_name:
  :regexp: !ruby/regexp /rbcat/mi
  :color: :green
```
```bash
$ echo "Rbcat it's a CLI tool written in ruby which reads from standard input (stdin),
colorizes content by set of regex rules from a config file, and then writes it
to standard output.
You can use rbcat in your ruby/ROR projects or as a standalone CLI tool (similar to grcat)." > description.txt

$ cat description.txt | rbcat --rules=rbcat_config.yaml
# or
$ rbcat --rules=rbcat_config.yaml < description.txt
```

![](https://hsto.org/webt/_u/5o/vu/_u5ovumrklgtx-akeqd_lbdpkys.png)


### Configuration
##### Configure

You can configure Rbcat this way:

```ruby
require 'rbcat'
require 'yaml'

Rbcat.configure do |config|
  config.rules = YAML.load_file(File.expand_path("rbcat_config.yaml"))
  config.predefined = [:logger]
end
```

And then anywhere in the ruby code just:

```ruby
puts Rbcat.colorize("String to colorize")
```

##### Regex rules and colors
Config contains rules. Each rule has options. Example:

```ruby
config = {
  ruby_word: {
    regexp: /ruby/m, # Regex mask (required)
    color: :red, # Color (required)
    once: true # Colorize only first occurrence, then skip others (optional, defalut value is false)
  }
}
```

##### Predefined sets

There are predefined sets of rules: **jsonhash** (colorizes strings that contain _json_ or _ruby hash_) and **logger** (colorizes _DEBUG_, _INFO_, _WARN_ and _ERROR_).

Usage: `--predefined=jsonhash,logger` (CLI), or `Rbcat::Colorizer.new(predefined: [:jsonhash, logger])` (ruby)

Let's see:

![](https://hsto.org/webt/ko/ui/dw/kouidw7sm_wcsitt-nfz88ydpf4.png)

![](https://hsto.org/webt/18/6g/wj/186gwj7o9rvsqipo2rspwbe958q.png)

![](https://hsto.org/webt/yv/vg/jv/yvvgjvjpobcyjziwcv1vyxln3u4.png)

You can use both custom and predefined rules in the same time.

##### Colors
To print all available colors: `$ rbcat --print_colors`

##### Yaml config
Correct yaml config should be convertible to the Ruby hash. Here is an example of Rbcat config in both Ruby hash and yaml:

```yaml
# rbcat_config.yaml

---
:ruby_word:
  :regexp: !ruby/regexp /ruby/m
  :color: :red
:upcase_words:
  :regexp: !ruby/regexp /[A-Z]{2,}/m
  :color: :bold
:inside_round_brackets:
  :regexp: !ruby/regexp /\(.*?\)/m
  :color: :cyan
:gem_name:
  :regexp: !ruby/regexp /rbcat/mi
  :color: :green
  :once: true
```

```ruby
# ruby hash

{
  ruby_word: {
    regexp: /ruby/m,
    color: :red
  },
  upcase_words: {
    regexp: /[A-Z]{2,}/m,
    color: :bold
  },
  inside_round_brackets: {
    regexp: /\(.*?\)/m,
    color: :cyan
  },
  gem_name: {
    regexp: /rbcat/mi,
    color: :green
    once: true
  }
}
```

### Using inside ruby project
It's a good idea to use rbcat with logger, so you can configure logger with colorizer once and then use it to print info to the console everywhere in the ruby code.

What we need to do is to [define formatter](http://ruby-doc.org/stdlib-2.5.0/libdoc/logger/rdoc/Logger.html#class-Logger-label-Format) for the logger, while creating one.

##### Using with a default ruby logger
Here is a simple example:
```ruby
require 'logger'
require 'rbcat'
require 'yaml'

# configure rbcat first
Rbcat.configure do |config|
  config.rules = YAML.load_file(File.expand_path("rbcat_config.yaml"))
end

# define formatter
formatter = proc do |severity, datetime, progname, msg|
  # default ruby logger layout:
  output = "%s, [%s#%d] %5s -- %s: %s\n".freeze % [severity[0..0], datetime, $$, severity, progname, msg]
  Rbcat.colorize(output)
end

# logger instance
logger = ::Logger.new(STDOUT, formatter: formatter)
logger.info "Message to colorize"
```

Usually, there are many classes and we need somehow to have access to colorized logger instance from everywhere. For this we can define logger module and then include it to every class where we need it:
```ruby
require 'logger'

module Log
  def logger
    @logger ||= begin
      ::Logger.new(STDOUT, formatter: proc { |severity, datetime, progname, msg|
        # default ruby logger layout
        output = "%s, [%s#%d] %5s -- %s: %s\n".freeze % [severity[0..0], datetime, $$, severity, progname, msg]
        Rbcat.colorize(output)
      })
    end
  end
end

class SomeClass
  include Log

  def print_message(msg)
    logger.info msg
  end
end

SomeClass.new.print_message("Colorized message")
```

In the example above, we still need every time to include Log module for every class. **There is another more convenient way**, using Log class with logger class methods:

```ruby
require 'logger'
require 'forwardable'

class Log
  class << self
    extend Forwardable
    delegate [:debug, :info, :warn, :error, :fatal] => :logger

    def logger
      @logger ||= begin
        ::Logger.new(STDOUT, formatter: proc { |severity, datetime, progname, msg|
          # default ruby logger layout
          output = "%s, [%s#%d] %5s -- %s: %s\n".freeze % [severity[0..0], datetime, $$, severity, progname, msg]
          Rbcat.colorize(output, predefined: [:logger])
        })
      end
    end
  end
end
```

![](https://hsto.org/webt/1f/vr/bc/1fvrbc5mlez-kmgromeidhky700.png)

With this approach, you can use colorized logger everywhere in the code.


##### Using with other logger libraries
[Logstash:](https://github.com/dwbutler/logstash-logger)

```ruby
require 'logstash-logger'
require 'rbcat'

logger = begin
  formatter = proc { |severity, datetime, progname, msg|
    output = "%s, [%s#%d] %5s -- %s: %s\n".freeze % [severity[0..0], datetime, $$, severity, progname, msg]
    Rbcat.colorize(output)
  }

  LogStashLogger.new(type: :stdout, formatter: formatter)
end

logger.info "Info message to colorize"
```


##### Write clear log to the file and print colorized output to the console at the same time
Suddenly, default ruby logger can't output info to the several sources at the same time. But it can do [Logstash](https://github.com/dwbutler/logstash-logger) for example:

```ruby
require 'logstash-logger'
require 'rbcat'

logger = begin
  formatter = proc { |severity, datetime, progname, msg|
    output = "%s, [%s#%d] %5s -- %s: %s\n".freeze % [severity[0..0], datetime, $$, severity, progname, msg]
    Rbcat.colorize(output)
  }

  outputs = [
    { type: :stdout, formatter: formatter },
    { type: :file, formatter: ::Logger::Formatter }
  ]

  LogStashLogger.new(type: :multi_logger, outputs: outputs)
end
```

### Q&A
##### I have a problem with a printing delay to the console using rbcat CLI
The same problem has [grcat](https://github.com/garabik/grc).

Example:

```bash
$ ruby -e "loop { puts 'INFO: This is info message'; sleep 0.1 }" | rbcat --predefined=logger
```

This code should print _"INFO: This is info message"_ to the console every 0.1 seconds. But its doesn't, because of nature of STDOUT buffering. [Here is a great article](https://eklitzke.org/stdout-buffering) about it.

One of possible solutions is to use **[unbuffer](https://linux.die.net/man/1/unbuffer)** tool (`sudo apt install expect` for ubuntu):

```bash
$ unbuffer ruby -e "loop { puts 'INFO: This is info message'; sleep 0.1 }" | rbcat --predefined=logger
```
Now message prints to the console every 0.1 seconds without any delay.

##### I don't like colors which colorizer prints
Colorizer uses [standard ANSI escape color codes](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors), but each terminal can have an individual color palette. You can install additional color schemes, [here](https://github.com/Mayccoll/Gogh) for example [themes](https://github.com/denysdovhan/one-gnome-terminal) for a Gnome terminal.


##### I want to temporary disable colorizer
Define environment variable `RBCAT_COLORIZER` with value `false`. Or use `RBCAT_COLORIZER=false` as the first parameter of command:

```bash
$ RBCAT_COLORIZER=false ruby grcat_example.rb
```

### License
MIT
