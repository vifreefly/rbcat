# frozen_string_literal: true

module Rbcat
  module Colors
    DEFAULT = {
      default:    "\033[0m",
      bold:       "\033[1m",
      underline:  "\033[4m",
      blink:      "\033[5m",
      reverse:    "\033[7m",
      concealed:  "\033[8m",

      black:      "\033[30m",
      red:        "\033[31m",
      green:      "\033[32m",
      yellow:     "\033[33m",
      blue:       "\033[34m",
      magenta:    "\033[35m",
      cyan:       "\033[36m",
      white:      "\033[37m",

      bold_black:   "\033[1;30m",
      bold_red:     "\033[1;31m",
      bold_green:   "\033[1;32m",
      bold_yellow:  "\033[1;33m",
      bold_blue:    "\033[1;34m",
      bold_magenta: "\033[1;35m",
      bold_cyan:    "\033[1;36m",
      bold_white:   "\033[1;37m",

      on_black:   "\033[40m",
      on_red:     "\033[41m",
      on_green:   "\033[42m",
      on_yellow:  "\033[43m",
      on_blue:    "\033[44m",
      on_magenta: "\033[45m",
      on_cyan:    "\033[46m",
      on_white:   "\033[47m",

      bright_black:      "\033[30;90m",
      bright_red:        "\033[31;91m",
      bright_green:      "\033[32;92m",
      bright_yellow:     "\033[33;93m",
      bright_blue:       "\033[34;94m",
      bright_magenta:    "\033[35;95m",
      bright_cyan:       "\033[36;96m",
      bright_white:      "\033[37;97m",

      on_bright_black:   "\033[40;100m",
      on_bright_red:     "\033[41;101m",
      on_bright_green:   "\033[42;102m",
      on_bright_yellow:  "\033[43;103m",
      on_bright_blue:    "\033[44;104m",
      on_bright_magenta: "\033[45;105m",
      on_bright_cyan:    "\033[46;106m",
      on_bright_white:   "\033[47;107m"
    }.freeze
  end
end
