module ClasslessMud
  module Commands
    module Admin
      class Edit
        def self.perform(game, player, message)
          case message.split[1]
          when 'quest'
            _, _, field, id, rest = message.split ' ', 5
            quest = game.find_quest id.to_i
            if quest
              case field
              when 'name'
                quest.update(name: rest)
                player.puts "Quest ##{quest.number} updated!"
              when 'description'
                ::ClasslessMud::Editor.new(player, quest.description, lambda { |new_description|
                  quest.update(description: new_description)
                  player.puts "Quest ##{quest.number} updated!"
                }).start!
              else
                edit_help(player)
              end
            else
              edit_help(player)
            end
          when 'item'
            _, _, keyword = message.split ' '
            item = player.find_in_inventory keyword
            if item
              ::ClasslessMud::ItemEditor.new(player, item.reload, lambda { |_new_description|
                player.puts "Item #{item.id} updated!"
              }).start!
            else
              edit_help player
            end
          when 'room'
            _, _, _, add_type, type, name = message.split
            if add_type == 'trigger'
              ::ClasslessMud::Editor.new(player, '', lambda { |code|
                trigger = player.room.triggers.create(type: type, name: name, code: code)
                player.puts "Trigger ##{trigger.id} created."
              }).start!
            else
              npc = ::ClasslessMud::Npc.create(
                name: 'cityguard',
                health: 10,
                level: 1,
                room: player.room
              )
              spawnpoint = Spawnpoint.create(
                npc_template: npc,
                max_alive: 1,
                room: player.room,
                time_interval: 5.minutes.to_i,
                last_spawn: Time.now
              )
              player.room.spawnpoints << spawnpoint
              player.room.save
            end
          else
            edit_help(player)
          end
        end

        def self.edit_help(player)
          player.puts 'Available subcommands:'
          player.puts '    quest name <id> <name>          Edit quest name'
          player.puts '    quest description <id>          Edit quest description'
          player.puts '    item <keyword>                  Edit item'
          player.puts '    room add trigger <type> <name>  Add a room trigger'
          player.puts '    room add spawn'
        end
      end
    end
  end
end
