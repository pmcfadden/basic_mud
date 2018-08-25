module ClasslessMud
  module Colorizer
    # To add more, look at this
    # alias colortest="python -c \"print('\n'.join([(' '.join([('\033[38;5;' + str((i + j)) + 'm' + str((i + j)).ljust(5) + '\033[0m') if i + j < 256 else '' for j in range(10)])) for i in range(0, 256, 10)]))\""
    CODES = {
      red:           '38;5;1',
      green:         '38;5;2',
      yellow:        '38;5;3',
      blue:          '38;5;4',
      purple:        '38;5;5',
      teal:          '38;5;7',
      white:         '38;5;8',
      black:         '38;5;16',
      bright_blue:   '38;5;27',
      grey:          '38;5;59',
      bright_teal:   '38;5;81',
      bright_green:  '38;5;83',
      bright_red:    '38;5;160',
      bright_white:  '38;5;195',
      bright_yellow: '38;5;226',
      bright_purple: '38;5;207'
    }.freeze

    def colorize(input, color)
      color_code = CODES[color]
      "\e[#{color_code}m#{input}\e[0m"
    end

    CODES.keys.each do |color|
      define_method(color) { |input| colorize(input, color) }
    end
  end
end
