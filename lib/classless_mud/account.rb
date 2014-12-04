module ClasslessMud
  class Account
    attr_reader :client, :game, :player

    def initialize client, game
      @client = client
      @game = game
    end

    def logged_in?
      not @player.nil?
    end

    def login_or_create
      client.puts 'Enter account name: '
      client.on do |account_name|
        player = Player.first(name: account_name)
        if player
          login player
        else
          create account_name
        end
      end
    end

    def handle_message message
      if logged_in?
        player.handle_message(message)
      else
        client.puts 'Invalid state. Exiting!'
        client.close_connection
      end
    end

    def login player
      client.puts "Password:"
      client.on do |password|
        if player.password == password
          login! player
        else
          login_or_create
        end
      end
    end

    def login! player
      @player = player
      player.client = client
      player.puts "Logged in as #{player.name}"
      game.add_player player
      player.save!
    end

    def create account_name
      client.puts "No account by the name #{account_name} exists. Create this account now? [y/N]"
      client.on do |confirm_create|
        if confirm_create == 'y' || confirm_create == 'Y'
          create_password account_name
        else
          login_or_create
        end
      end
    end

    def create_password account_name
      client.puts "Ok, #{account_name}. What is your password?"
      client.on do |password|
        client.puts "Confirm password:"
        client.on do |confirm_password|
          if password == confirm_password
            player = Player.new(name: account_name, password: password)
            login! player
          else
            client.puts "Retrying.."
            create_password account_name
          end
        end
      end
    end
  end
end
