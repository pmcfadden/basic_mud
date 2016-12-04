module ClasslessMud
  module Commands
    module Admin
      class Create
        def self.perform game, player, message
          case message.split[1]
          when 'item'
            item = Item.create(name: 'A hint of an item')
            player.puts "Item ##{item.id} created!"
            ::ClasslessMud::ItemEditor.new(player, item, lambda { |new_description|
              player.items << item
              player.items.save!
              player.puts "#{item.name} added to your inventory."
            }).start!
          when 'quest'
            quest = Quest.create(number: game.max_quest_number + 1)
            game.add_quest quest
            player.puts "Quest ##{quest.number} created! Describe this new quest:"
            ::ClasslessMud::Editor.new(player, '', lambda { |new_description|
              quest.update(description: new_description)
              player.puts "Quest ##{quest.number} updated!"
            }).start!
          when 'room'
            room = ::ClasslessMud::Room.create(description: 'A new room made from the mists.', number: game.world.max_room_number + 1)
            game.world.add_room room
            player.puts "Creating a new room (##{room.number}) and transporting you there."
            player.room.exit player
            room.enter player
          when 'description'
            room = player.room
            ::ClasslessMud::Editor.new(player, room.description, lambda { |new_description|
              room.update(description: new_description)
              player.puts "Room description updated."
            }).start!
          when 'exit'
            from_room = player.room
            direction, to_room_number, rest = message.split[2..-1]
            if rest
              exit_help(player, "Too many arguments (#{rest})")
            elsif !to_room_number[/\d+/]
              exit_help(player, "Room number (#{to_room_number}) not a number")
            elsif !Exit::DIRECTIONS.include?(direction)
              exit_help(player, "Invalid direction (#{direction})")
            else
              to_room = game.room_with_number(to_room_number.to_i)
              if to_room.find_exit(Exit.opposite(direction)) || from_room.find_exit(direction)
                exit_help(player, 'That exit already exists!')
              else
                from_room.exits.create!(
                  direction: direction,
                  target: to_room
                )
                to_room.exits.create!(
                  direction: Exit.opposite(direction),
                  target: from_room
                )
                player.puts "Exit created! (#{direction}: #{to_room_number})"
              end
            end
          else
            player.puts "Available subcommands:"
            player.puts "    description  Edit current room description"
            player.puts "    exit         Create an exit"
            player.puts "    quest        Create a new quest"
            player.puts "    room         Create a new room"
          end
        end

        def self.exit_help player, reason
          player.puts "Help for creating exits (#{reason}):"
          player.puts "    create exit <direction> <room #>"
          player.puts "Directions: #{Exit::DIRECTIONS.join(' ')}"
        end
      end
    end
  end
end
