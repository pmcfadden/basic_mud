module ClasslessMud
  module Commands
    module Admin
      class Delete
        def self.perform game, player, message
          case message.split[1]
          when 'exit'
            from_room = player.room
            direction = message.split[2]
            if !Exit::DIRECTIONS.include?(direction)
              exit_help(player, "Invalid direction (#{direction})")
            else
              to_room_exit = from_room.find_exit(direction)
              if to_room_exit
                from_room_exit = to_room_exit.target.find_exit(Exit.opposite(direction))
                to_room_exit.source.exits.delete(to_room_exit)
                to_room_exit.destroy
                if from_room_exit
                  from_room_exit.source.exits.delete(from_room_exit)
                  from_room_exit.destroy
                end
                player.puts "Exit deleted! (#{direction}: #{to_room_exit.target.number})"
              else
                player.puts "That exit doesn't exist."
                player.puts "Exits: #{player.room.exits.map(&:direction).join(' ')}"
              end
            end
          else
            player.puts "Available subcommands:"
            player.puts "    exit         Delete an exit"
          end
        end

        def self.exit_help player, reason
          player.puts "Help for creating exits (#{reason}):"
          player.puts "    delete exit <direction>"
          player.puts "Directions: #{Exit::DIRECTIONS.join(' ')}"
        end
      end
    end
  end
end
