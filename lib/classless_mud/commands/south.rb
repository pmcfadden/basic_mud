# frozen_string_literal: true

module ClasslessMud
  module Commands
    class South
      def self.perform(game, player, _message)
        Move.perform game, player, 'south'
      end
    end
  end
end
