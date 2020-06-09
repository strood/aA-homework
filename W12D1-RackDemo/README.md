These notes cover a basic rails app, and additional middleware demos for
examples to be used when making rails lite.

rack demo - Displays a few different rack apps that can be loaded up and
work in diffrent ways.

rackl middlewre demo - Show us how to integrate middleware into our rack
to achieve things that are generic to many web apps, without actually
incorporating it into the web app itself, instead it sits between
webserver and webapp with rack and works there. 

catAPI - Will be sinple web api webserver to return some cats. We will do
some HTTP parsing in it. 
- /bin/cat_server.rb -super basic, shows how to mess around
- /bin/cat_server2.rb - Add some webserver functionality.

- TO CONNECT AND MESS WITH SERVER USE NETCAT Ex:

nc localhost 3000
CREATE
Bob
