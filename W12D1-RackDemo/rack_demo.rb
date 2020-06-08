require 'rack'
require 'json'

#Start a webserver, and mount a rack applicaiton on top of that

#Simple example to outline basic function and output of a valid rack app
class RackApplication
    #In order to be a rack apop, must be ruby object and respond
    #to the method.
    def self.call(env)
        #Rack element must pass back correct format response:
        #Array where first ele=status code, second is hash w/ headers
        #Last one is the body in array
        ['200', {'Content-Type' => 'text/html'}, ["Hey There"]]
    end
end


#Returns the name param if given, but we dont specify content type, so
# rendered as html as the last one was
class SimpleApp
    def self.call(env)
        #Rack utility classes can make the header parse easier.
        #Rack::Request and Rack::Reqponse
        req = Rack::Request.new(env)
        #Above line formats, and adds functionality to our array. instead
        #of barebones array above


        res = Rack::Response.new

        name = req.params['name']
        #gives us params hash of query sting and req body
        res.write("Hello #{name}")
        res.finish #Returns properly formatted array
    end
end


#HTTP-COOKIE is a part of the http response we can use for persistance,
# this rack application will take advantage of that

class CookieApp
    def self.call(env)
        #set up res and req with extended funct
        req = Rack::Request.new(env)
        res = Rack::Response.new

        food = req.params['food']
        if food
            #first arg is name of cookie, 
            #second is obj/hash w k/v pairs for cookie attributes
            #path "sets where its available from, if you set "/" it is
            #root, so avail across app. **CAUTION**
            res.set_cookie('_my_cookie_app',
                            {path: "/",
                             value: {food: food}.to_json})
        else
           #If there is already a cookie, and none in params, display
            #body w/ fav food instead.Below we retrieve and parse from
            # the earlier named cookie
           cookie = req.cookies['_my_cookie_app']
           cookie_val = JSON.parse(cookie)
           food = cookie_val['food']
           res.write ("Your favorite food is #{food}")      
    
        end
        
        res.finish
    end
end


#Our Rack app does not have to be a class, all it has to do is respond to
#the method call, take in one arg, and return a properly formatted rakc
#response
#Proc objs respond to call, when received they just repspond

app = Proc.new do |env|
    req = Rack::Request.new(env)
    res = Rack::Response.new

    #This will show how to redirect in a web app. 
    # Al we need to do is set the status code, and location header      
    # The status code 302 means redirecty, and the browser will look to
    # the location specified in locaiton header when it sees that status
    # code. Example below:

    if req.path.start_with?("/cage")
       res.status = 302
       res['Location'] = 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/nicolas-cage-1580830257.jpg?crop=0.491xw:0.983xh;0,0&resize=768:*' 
    else
        res.write("Nothing to see here")
    end

    res.finish
end



#Start the server, name the web app, and the listening port.
Rack::Server.start({
    app: app,
    Port: 3000
})


