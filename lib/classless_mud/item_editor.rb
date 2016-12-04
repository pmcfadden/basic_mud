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
        number, *value = message.split(' ')
        value = value.join(' ')
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
        else
          help_text
        end
      end
    end

    private

    def puts_values
      message = <<-EOS
      [1] Name              : #{@item.name}
      [2] Short Description : #{@item.short_description}
      [3] Keywords          : #{@item.keywords}
      [4] Edible            : #{@item.edible}
      EOS
      @player.puts message
    end

    def help_text
      message = <<-EOS
      You are editing item #{item.id}.
      To update a value type "<number> <value>". For example, to
      update the item name:

        1 New Name

      Other commands:

        help
        done
      EOS
      @player.puts message
    end
  end
end
