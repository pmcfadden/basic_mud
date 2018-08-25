module ClasslessMud
  class FightCommands
    def self.parse(message)
      if message =~ /flee/
        Flee.new
      elsif message =~ /attack/
        Attack.new
      else
        NoAction.new
      end
    end
  end

  class NoAction
    def perform(_game, player, fight, _message)
      player.puts <<-EOS
#{fight.title}
You can
 * flee   :: Run away from the fight
 * attack :: Roll a #{player.damage_die} for damage
      EOS
    end
  end

  class Flee
    def perform(_game, player, fight, _message)
      other = fight.other(player)
      player.end_fight!
      other.end_fight!
      player.puts 'You run away from the fight!'
      other.puts "#{player.name} runs away from the fight!"
    end
  end

  class Attack
    def perform(_game, player, fight, _message)
      player.puts 'You attack!'
      fight.other(player).puts "#{player.name} attacks you!"
      fight.attack!
    end
  end
end
