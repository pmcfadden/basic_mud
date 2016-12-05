module ClasslessMud
  class ItemEditor
    def initialize(player, item, editor_callback)
      @player = player
      @item = item
      @editor_callback = editor_callback
    end

    def start!
      @player.puts 'Editing...'
      puts_values
      @player.editor!(self)
    end

    def complete!
      @player.puts 'Finished!'
      @editor_callback.call(@item)
      @player.end_editor!
    end

    def handle(message)
      if message == 'done'
        @item.save
        complete!
      elsif message == 'help'
        help_text
      elsif message.split(' ').size < 2
        help_text
      else
        number, *split_value = message.split(' ')
        value = split_value.join(' ')
        case number
        when '1'
          @item.update(name: value)
          puts_values
        when '2'
          @item.update(short_description: value)
          puts_values
        when '3'
          @item.update(keywords: value)
          puts_values
        when '4'
          @item.update(edible: value)
          puts_values
        when '5'
          type, *trigger_name_split = split_value
          if trigger_name_split.empty?
            help_text
          else
            @player.puts 'Code for trigger...'
            ::ClasslessMud::Editor.new(@player, '', lambda { |code|
              @item.triggers.create(type: type, name: trigger_name_split.join(' '), code: code)
              @player.editor!(self)
              puts_values
            }).start!
          end
        when /^\d+$/
          max_valid_value = 5 + (@item.triggers.size * 2)
          if number.to_i <= max_valid_value
            if number.to_i < (5 + @item.triggers.size)
              index = number.to_i - 5
              ::ClasslessMud::Editor.new(@player, @item.triggers[index].code, lambda { |code|
                @item.triggers[index].update(code: code)
                @player.editor!(self)
                puts_values
              }).start!
            else
              index = number.to_i - 5 - @item.triggers.size
              @item.triggers[index].delete
            end
          else
            help_text
          end
        else
          help_text
        end
      end
    end

    private

    def puts_values
      message = <<~EOS
      [1] Name              : #{@item.name}
      [2] Short Description : #{@item.short_description}
      [3] Keywords          : #{@item.keywords}
      [4] Edible            : #{@item.edible}
      [5] Add trigger: 5 <type> <name>

      Triggers:
      #{trigger_values}
      EOS
      @player.puts message
    end

    def trigger_values(initial_index = 6)
      edits = @item.triggers.each_with_index.map do |trigger, i|
        "[#{initial_index + i}] Edit trigger #{trigger.id} (#{trigger.name})"
      end.join("\n")

      deletes = @item.triggers.each_with_index.map do |trigger, i|
        "[#{initial_index + @item.triggers.size + i}] Delete trigger #{trigger.id} (#{trigger.name})"
      end.join("\n")

      [edits, deletes].join("\n")
    end

    def help_text
      message = <<~EOS
      You are editing item #{@item.id}.
      To update a value type "<number> <value>". For example, to
      update the item name:

        1 New Name

      For adding triggers:

        5 <type> <name>

        Types: get interaction

      Other commands:

        help
        done
      EOS
      @player.puts message
    end
  end
end
