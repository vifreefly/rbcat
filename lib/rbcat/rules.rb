module Rbcat
  module Rules
    JSONHASH = {
      value_integer: {
        regexp: /(?<=\"\:)\d+|(?<=\=\>)\d+/m,
        color: :cyan
      },
      key_string: {
        regexp: /\"[^\"]*\"(?=\:)/m,
        color: :green
      },
      key_symbol: {
        regexp: /\:[\p{L}\_\d]*(?=\=\>)|\:\"[^\"]*\"(?=\=\>)/m,
        color: :magenta
      },
      value_string: {
        regexp: /\"(?:[^"\\]|\\.)*\"(?=[\,\n\}\]])/m,
        color: :yellow
      },
      value_null_nil: {
        regexp: /(?<=\:)null|(?<=\=\>)nil/m,
        color: :magenta
      },
      value_true_false: {
        regexp: /(?<=\:)(false|true)|(?<=\=\>)(false|true)/m,
        color: :magenta
      }
    }.freeze

    LOGGER = {
      info_logger: {
        regexp: /INFO(\s--\s:|)/m,
        color: :cyan,
        once: true
      },
      error_logger: {
        regexp: /ERROR(\s--\s:|)/m,
        color: :red,
        once: true
      },
      warn_logger: {
        regexp: /WARN(\s--\s:|)/m,
        color: :yellow,
        once: true
      },
      debug_logger: {
        regexp: /DEBUG(\s--\s:|)/m,
        color: :green,
        once: true
      }
    }.freeze
  end
end
