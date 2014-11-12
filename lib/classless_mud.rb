require 'socket'

require "classless_mud/version"

module ClasslessMud
  server = TCPServer.new 2000

  puts "Starting server on port 2000"
  loop do
    Thread.start(server.accept) do |client|
      client.puts "Enter name:"
      name = client.gets
      client.puts "Hello #{name}"
      client.close
    end
  end
end
