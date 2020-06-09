require 'socket'

#include thread to make it multi-socket to handle many connections
require 'thread'
# Needed for to_jon
require 'json'


# Normally can connect ot DB to store data, we will just use an array to smplify things
$cats = []
$id = 0

server = TCPServer.new(3000)

def handle_request(socket)
  # Build a thread to handle each request
  #Master thread that calls new thread never gets stuck waiting, so can always
  #be ready to accept a new connection and make new thread.
  Thread.new do
    cmd = socket.gets.chomp


    # Filter based on command given
    case cmd
    when "INDEX"
      socket.puts $cats.to_json
    when "SHOW"
      cat_id = Integer(socket.gets.chomp)
      cat = $cats.find { |cat| cat[:id] == cat_id }
      socket.puts cat.to_json
    when "CREATE"
      name = socket.gets.chomp
      cat_id = $id
      $id += 1
      $cats << { id: cat_id, name: name }
    when "UPDATE"
      cat_id = Integer(socket.gets.chomp)
      cat = $cats.find { |cat| cat[:id] = cat_id}

      new_name = socket.gets.chomp
      cat[:name] = new_name
    when "DESTROY"
      cat_id = Integer(socket.gets.chomp)
      $cats.reject! { |cat| cat[:id] == cat_id }
    end
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
