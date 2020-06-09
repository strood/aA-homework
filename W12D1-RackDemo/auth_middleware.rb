# Simple authentication middleware example.
# Will check if request if going to /admin, if it is, it will check the username
# and password of the requesting user.

require 'rack'

class AuthMiddleware
  attr_reader :app

  def initialize(app)
  #Neeed to use initialize as middleware will have .new called on it
  #when created.
  #When initialize called, passes in the app thts coming next. Saved in instance var
    @app = app
  end

  def call(env)
    # make request into a ruby object with Rack::Request
    req = Rack::Request.new(env)

    # Check if we need to check for admin or not by checking path.
    if req.path.match(/^\/admin/)
      # If admin path, we will carry out functionality.
      authenticate_admin(req)
    else
      # If not admin path, we just send to next app in middleware stack
      app.call(env)
    end
  end

  private

  def authenticate_admin(req)
    if valid_admin?(req)
      # Pass request on to next middleware in stack, they check out
      app.call(req.env)
    else
      # Deny entry and do not pass the request further in stack. Return 401 immidiatly
      ['401', {}, ['Unauthorized']]
      # Above you are constructing a response. [Code, path, body]
    end
  end

  def valid_admin?(req)
    req.params['username'] == 'admin' && req.params['password'] == 'password123'
  end

end

# Proc object often used as app object as it responds to call method by default
# This is just as simple app for demonstration, could be Rails or other
# full web framework the request eventually goes to.
hey_app = Proc.new do |env|
  puts "Hello friend!"

end

# We build our app with Rack::Builder so we can specify and arrange our middleware
# stack, loads bototm up, runs top down. Passing between middlewars in the stack
# until poassing along to our run app. We convert this object thats created into an
# app object sop we can call it in Rack::Server.start
app = Rack::Builder.new do
  use AuthMiddleware
  run hey_app
end.to_app

# Start our rack serer, specifying rack app and port to use.
#Rack app must respond to call method, take in env var (Specific reqs online)
Rack::Server.start({
  app: app,
  Port: 3000
  })
