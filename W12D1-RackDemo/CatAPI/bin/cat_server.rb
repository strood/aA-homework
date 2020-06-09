require 'socket'

#include thread to make it multi-socket to handle many connections
require 'thread'

server = TCPServer.new(3000)

def handle_request(socket)
  # Build a thread to handle each request
  #Master thread that calls new thread never gets stuck waiting, so can always
  #be ready to accept a new connection and make new thread. 
  Thread.new do
    socket.puts("Thanks for connecting")
    socket.puts('What is your name, human?')
    name = socket.gets.chomp
    socket.puts("Goodbye #{name}")
    # Close connection
    socket.close
  end
  puts "Spawned worker thread, main thread is continuing."
end


# Runs in a loop until shut down, common for server
while true
  # To start server, $rails bin/cat_Server.rb
  # Start serrver listening for requests.
  socket = server.accept
  # Send new connections to handle_request method so we can handle many
  handle_request(socket)
end
