module ClasslessMud
  MOTD = <<EOS
                  .-~~~~~~~~~-._       _.-~~~~~~~~~-.
              __.'              ~.   .~              `.__
            .'//  We    are       \./    awesome.      \\`.
          .'//                     |                     \\`.
        .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
      .'//.-"                 `-.  |  .-'                 "-.\\`.
    .'//______.============-..   \ | /   ..-============.______\\`.
  .'______________________________\|/______________________________`.
EOS

  class Client < EventMachine::Connection
    attr_accessor :game
    attr_reader :account

    def initialize
      @logged_in = false
      @callbacks = []
    end

    def start
      send_data MOTD
      @account = ::ClasslessMud::Account.new(self, game)
      account.login_or_create
    end

    def receive_data data
      data = data.chomp
      if @callbacks.any?
        callback = @callbacks.pop
        callback.call(data)
        return
      end
      account.handle_message(data)
    end

    def on &callback
      @callbacks.push callback
    end

    def puts message
      send_data "#{message}\n"
    end
  end
end
