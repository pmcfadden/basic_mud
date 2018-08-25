# frozen_string_literal: true

module ClasslessMud
  class Editor
    def initialize(player, initial_value, editor_callback)
      @player = player
      @editor_callback = editor_callback
      @message = initial_value
    end

    def start!
      @player.puts 'Editing...'
      @player.puts 'For help, just type help or ?'
      @player.puts 'Otherwise, just type your message and when you are done, type done'
      @player.editor!(self)
    end

    def complete!
      @player.puts 'Finished!'
      @player.end_editor!
      @editor_callback.call(@message)
    end

    def handle(message)
      case message
      when 'clear'
        @message = ''
        @player.puts 'Message cleared.'
      when 'show'
        show_msg = @message.split("\n").each_with_index.map { |s, i| "#{i + 1}. #{s}" }.join("\n")
        @player.puts show_msg
      when /^delete/
        row = message[/\d+/].to_i
        tmp_message_lines = @message.split("\n")
        tmp_message_lines.delete_at(row)
        @message = tmp_message_lines.join("\n")
        @player.puts @message
      when 'done'
        complete!
      when 'help', '?'
        @player.puts 'Available commands:'
        @player.puts '  help'
        @player.puts '  done'
        @player.puts '  show (this show line numbers)'
        @player.puts '  delete <#>'
        @player.puts '  clear'
      else
        @message += encode(message) + "\n"
      end
    end

    def encode(message)
      message.encode(Encoding.find('UTF-8'), invalid: :replace, undef: :replace, replace: '')
    end
  end
end
