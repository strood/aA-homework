require 'rack'

#Our middleware will be an app that logs all our incoming requests
# and put it in a log file, we will create it here below

class LoggerMiddleware
    attr_reader :app
    def initialize(app)
       #Neeed to use initialize as middleware will have .new called on it
       #when created. 
        #When initialize called, passes in the app thts coming next. Save
        # in instance var
       
       puts "Initializing Logger"
       p app #Prints app, which we see is a Proc.  
       @app = app
    end
    
    def call(env)
        # This is where it actually runs
        puts "Calling Logger"
        # We want to write the log when caled
        write_log(env)
       
        #proceed to next app in stack
        app.call(env)
    end


    private

    def write_log(env)
        #Open application log in append mode.
        log_file = File.open('application.log', 'a')
        
        #Get text to log, using a heredoc
        log_text = <<-LOG
        TIME: #{Time.now}
        IP: #{env['REMOTE_ADDR']}
        PATH: #{env['REQUEST_PATH']}
        _____________________________\n
        LOG

        #Write log-text to log_file
        log_file.write(log_text)
        
        #Close file once done 
        log_file.close
    end
end

#New Middleware that will filter out internet explorer reqiuests, and
#redirect them to the chrome download page

class BrowserFilter
    attr_reader :app
    def initialize(app)
        puts "Init browser filter"
        p app
        @app = app
    end

    def call(env)
        puts "Calling browser-filter"
        res = Rack::Response.new

        if env["HTTP_USER_AGENT"].include?("MSIE")
            res.status = 302
            res['Location'] = 'https://www.google.com/chrome/'
            res.finish

        else
            #If they dont ahve IE, we just call next app in stack. 
            app.call(env)
        end

    end
end




#Basic rack app rendering an html file we have created.
hey_app = Proc.new do |env|
    puts "Calling hey-app"
    req = Rack::Request.new(env)
    res = Rack::Response.new

    file = File.open('index.html', 'r')
    lines = file.read

    res.write(lines)
    res['Content-Type'] = 'text.html'
    
    res.finish 
end


#Using rack builder you can add your middleware to the rack middleware
#stack

app = Rack::Builder.new do
    #Using rack-builder DSL, you say what middleware to use, and which
    # app to run, this then becomes the app you pass to server start
    use LoggerMiddleware #Could be many of these middleware to use
    use BrowserFilter #Lower listed middleware initialized first. 
    run hey_app
    #returns a rack-builder object, so need to convert to rack app below
end.to_app


Rack::Server.start({
    app: app,
    Port: 3000
})
