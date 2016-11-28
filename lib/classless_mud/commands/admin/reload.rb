module ClasslessMud
  module Commands
    module Admin
      class Reload
        def self.perform game, player, message
          player.puts 'WARNING: Reloading classes from disk.'
          player.puts 'WARNING: This should really only be done in development.'

          if Object.const_defined?("ClasslessMud")
            Object.send(:remove_const, "ClasslessMud")
          end
          puts $"
          $".delete_if {|s| s.include?('classless_mud') }
          require 'classless_mud'
        end
      end
    end
  end
end
