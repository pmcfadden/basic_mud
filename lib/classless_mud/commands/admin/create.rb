module ClasslessMud
  module Commands
    module Admin
      class Create
        def self.perform game, player, message
          case message.split[1]
          when 'room'
            room = ::ClasslessMud::Room.create(description: 'A new room made from the mists.', number: game.world.max_room_number + 1)
            game.world.add_room room
            player.puts "Creating a new room (##{room.number}) and transporting you there."
            player.room.exit player
            room.enter player
          when 'description'
            room = player.room
            ::ClasslessMud::Editor.new(player, room.description, lambda { |new_description|
              room.description = new_description
              room.save
              player.puts "Room description updated."
            }).start!
          else
            player.puts "Available subcommands:"
            player.puts "    room"
          end
        end
      end
    end
  end
end
