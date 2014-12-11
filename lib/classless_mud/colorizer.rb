module ClasslessMud
  module Colorizer
    CODES = {
      red: 31,
      green: 32,
      yellow: 33
    }

    def colorize(input, color)
      color_code = CODES[color]
      "\e[#{color_code}m#{input}\e[0m"
    end

    def red(input)
      colorize(input, :red)
    end

    def green(input)
      colorize(input, :green)
    end

    def yellow(input)
      colorize(input, :yellow)
    end
  end
end
