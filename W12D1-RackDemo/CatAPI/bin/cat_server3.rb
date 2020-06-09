require 'socket'

#include thread to make it multi-socket to handle many connections
require 'thread'
# Needed for to_json
require 'json'


# Using TCP to transfer data back and forth from client and server
# On top of that we built a Bespoke protocol. (cat_server2.rb)
# We want to replace that with HTTP

# We would send, to www.google.com port 80
# GET / HTTP/1.1
# Host: www.google.com

# METHOD:  PATH   PROTOCOL_VERSION
# HEADERS: Header_name: Header_value

# -GET   /cats  HTTP/1.1
# -POST  /cats HTTP/1.1
# -PATCH  /cats/:id HTTP/1.1
# -DELETE /cats HTTP/1.1



# Normally can connect ot DB to store data, we will just use an array to smplify things
$cats = [
  { "id" => 1, "name" => "Markov" },
  { "id" => 2, "name" => "Heather" }
]
$id = 2

server = TCPServer.new(3000)

def handle_request(socket)
  # Build a thread to handle each request
  #Master thread that calls new thread never gets stuck waiting, so can always
  #be ready to accept a new connection and make new thread.
  Thread.new do

    # METHOD PATH PROTOCOL_VERSION
    line1 = socket.gets.chomp

    # Use REGEX to filter out what we want (Method and path here)
    # This grabs the method and path
    re = /([^ ]+) ([^ ]+) HTTP\/1.1$/
    match_data = re.match(line1)
    verb = match_data[1]
    path = match_data[2]


    cat_regex = /\/cats\/(\d+)/

    if [verb, path] == ["GET", "/cats"]
      # GET /cats
      # index action
      socket.puts $cats.to_json

    elsif verb == "GET" && cat_regex =~ path
      # GET /cats/:id
      # Show action
      match_data2 = cat_regex.match(path)
      cat_id = Integer(match_data2[1])
      cat = $cats.find { |cat| cat["id"] == cat_id }

      socket.puts cat.to_json
    elsif verb == "DELETE" && cat_regex =~ path
        # DELETE /cats/:id
        match_data2 = cat_regex.match(path)
        cat_id = Integer(match_data2[1])
        $cats.reject! { |cat| cat["id"] == cat_id }

        socket.puts true.to_json

    elsif [verb, path] == ["POST", "/cats"]
        #   # POST /cats
        # Create action
        # Gives number of bytes of posted data
        header1 = socket.gets.chomp
        # Take in header data
        match_data2 = /Content-Length: (\d+)/.match(header1)
        content_length = Integer(match_data2[1])

        socket.gets.chomp #reads a blank line  (knows body is coming) **KEY**

        body_data = socket.gets.chomp #Read in body
        # body_data.length == content_length else error #CHEC TO MAKE sure legit! (NOT DOING ATM)

        cat = JSON.parse(body_data) #parse down json body

        cat["id"] = ($id += 1) #increment cat id while setting our new cats id
        $cats << cat # add new cat to cat array

        # DOesnt create anythiong
        socket.puts cat.to_json

    elsif verb == "PATCH" && path =~ cat_regex
        #   # PATCH /cats/:id
        # Update action
        # Gives number of bytes of posted data
        header1 = socket.gets.chomp
        # take in header data
        match_data2 = /Content-Length: (\d+)/.match(header1)
        content_length = Integer(match_data2[1])

        socket.gets.chomp #reads a blank line  (knows body is coming) **KEY**

        body_data = socket.gets.chomp #Read in body
        # body_data.length == content_length else error #CHEC TO MAKE sure legit! (NOT DOING ATM)

        parsed_body_data = JSON.parse(body_data) #parse down json body

        match_data2 = cat_regex.match(path)
        cat_id = Integer(match_data2[1])

        cat = $cats.find { |cat| cat["id"] == cat_id }
        parsed_body_data.each do |(key, value)|
          cat[key] = value
        end

        socket.puts cat.to_json
    end
      # Ignore for now
    #
    # when "CREATE"
    #   # POST /cats
    #
    #   name = socket.gets.chomp
    #   cat_id = $id
    #   $id += 1
    #   $cats << { id: cat_id, name: name }
    # when "UPDATE"
    #   # POST /cats/:id
    #
    #   cat_id = Integer(socket.gets.chomp)
    #   cat = $cats.find { |cat| cat[:id] = cat_id}
    #
    #   new_name = socket.gets.chomp
    #   cat[:name] = new_name
    # end


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
