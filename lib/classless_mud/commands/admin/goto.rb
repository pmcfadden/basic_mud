# frozen_string_literal: true

module ClasslessMud
  module Commands
    module Admin
      class Goto
        def self.perform(_game, player, message)
          room_number = message.split[1]
          if room_number.match?(/^\d+$/)
            room = Room.first(number: room_number)
            if room
              player.puts "Transporting you to room ##{room.number}."
              player.room.exit player
              room.enter player, "Admin #{player.name} has appeared in the room."
            else
              help_message player
            end
          else
            help_message player
          end
        end

        def self.help_message(player)
          player.puts 'Usage:'
          player.puts '    goto <room#>'
        end
      end
    end
  end
end
