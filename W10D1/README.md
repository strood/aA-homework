TESTING IN RAILS

CapyBaraParty is demopnstrating basic testing frameworks and how to write
these tests with some useful notes.

GEMS FOR TESTING:
rspec-rails - allows rspec tests to be written in rails
factory_bot_rails -allows creatiion of mass objects ext to simplify tests
faker - generate fake user data
capybara - front end automation- user interaction, views/template testing
should-matchers ~>3.1 - validation & association testing simplification
launchy - allows you to launch apps from test to see more details on what test
          is seeing


rails g rspec:install to set up rspec auto generation to get this form
on creation of model, controller ect

ONCE WRITTEN, RUN WITH :
$ bundle exec rspec spec/models/capy_spec.rb
