# frozen_string_literal: true

module ClasslessMud
  module Commands
    CONNECTORS = ['to'].freeze
    class Whisper
      def self.perform(_game, player, message)
        _, target, *target_message = message.split(' ').reject { |word| CONNECTORS.include?(word.downcase) }
        target_char = player.room.find_character target
        if target_char.nil?
          player.puts "You can't seem to find them here."
        else
          target_char.puts %(#{player.name} whispers, "#{target_message.join(' ')}")
          player.puts %(You whisper to #{target_char.name}, "#{target_message.join(' ')}")
        end
      end
    end
  end
end
