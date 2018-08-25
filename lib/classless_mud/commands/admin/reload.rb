# frozen_string_literal: true

module ClasslessMud
  module Commands
    module Admin
      class Reload
        def self.perform(_game, player, _message)
          player.puts 'WARNING: Reloading classes from disk.'
          player.puts 'WARNING: This should really only be done in development.'

          if Object.const_defined?('ClasslessMud')
            Object.send(:remove_const, 'ClasslessMud')
          end
          puts $LOADED_FEATURES
          $LOADED_FEATURES.delete_if { |s| s.include?('classless_mud') }
          require 'classless_mud'
        end
      end
    end
  end
end
