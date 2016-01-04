require_relative 'bad_command'

module ClasslessMud
  module Commands
    # This is the commands command. The naming is weird, but this lists out all available commands
    class Commands
      COMMANDS_TO_HIDE = [ClasslessMud::Commands::BadCommand]

      def self.commands
        ClasslessMud::Commands.constants
           .select { |c| Class === ClasslessMud::Commands.const_get(c) }
           .reject { |c| COMMANDS_TO_HIDE.include?(ClasslessMud::Commands.const_get(c)) }
           .map { |c| c.to_s.downcase }
      end

      def self.perform game, player, message
        player.puts columnize(commands)
      end

      def self.columnize array, width=4
        result = ''
        longest_char = array.max_by(&:size).size
        array.each_slice(width) do |row|
          spaced_rows = row.map { |word| "%#{longest_char}s" % word }
          result += spaced_rows.join(" ") + "\n"
        end
        result
      end
    end
  end
end
