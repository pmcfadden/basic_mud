# frozen_string_literal: true

require_relative 'bad_command'

module ClasslessMud
  module Commands
    # This is the commands command. The naming is weird, but this lists out all available commands
    class Commands
      COMMANDS_TO_HIDE = [ClasslessMud::Commands::BadCommand].freeze

      def self.commands
        ClasslessMud::Commands.constants
                              .select { |c| Class === ClasslessMud::Commands.const_get(c) }
                              .reject { |c| COMMANDS_TO_HIDE.include?(ClasslessMud::Commands.const_get(c)) }
                              .map { |c| c.to_s.downcase }
      end

      def self.admin_commands
        ClasslessMud::Commands::Admin.constants
                                     .select { |c| Class === ClasslessMud::Commands::Admin.const_get(c) }
                                     .reject { |c| COMMANDS_TO_HIDE.include?(ClasslessMud::Commands::Admin.const_get(c)) }
                                     .map { |c| c.to_s.downcase }
      end

      def self.perform(_game, player, _message)
        player.puts columnize(commands)
        if player.admin?
          player.puts 'Admin Commands'
          player.puts '=============='
          player.puts columnize(admin_commands)
        end
      end

      def self.columnize(array, width = 4)
        result = ''
        longest_char = array.max_by(&:size).size
        array.each_slice(width) do |row|
          spaced_rows = row.map { |word| format("%#{longest_char}s", word) }
          result += spaced_rows.join(' ') + "\n"
        end
        result
      end
    end
  end
end
