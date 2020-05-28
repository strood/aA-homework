--Cookies--

-Because HTTP is stateless(no knowledge carry-over), we need a way to persist
information about a session across requests so that we can do things like verify
user identity,and ensure privacy for anything related especially to that user,
like a cart,account, or settings.

Ex of an interaction at amazon:

Request:
    POST /session HTTP/1.1
    Host: amazon.com

    user=ruggeri&password=gizmo_is_great

Response:
    HTTP/1.1 302
    Set-Cookie: user=ruggeri; session_token=135792468
    Location: http://www.amazon.com/
----------------------------------------------------------------------------
--In the above we post creds to amazon to verify. Amazon sends response telling
our browser to make a new request for amazon homepage (302 redirect), but the
response also has a "Set-Cookie" header line

"Set-Cookie" - tells the client(browser) to save some state in the browser,
in this case, the logged in amazon user and a randomly generated session_token.
It is now the browsers job to upload this session_token in all subsequent
requests to amazon.com.
ie

GET /wishlist http/1.1
Host: www.amazon.com
Cookie: user=ruggeri; session_token=135792468

--------------------------------------------------------------------------------
The way the server verifies who is making requests is through this cookie.
The server will compare this cookie to the one it set up on the server at time of
creation to ensure not forged, and is correct session cookie.
----
Once set the cookie is continually sent up with each request until it expires or
is cleared by user at which time we will need to regenerate one.
Can set cookies to never expire, or not set an expiry which will cause it to be
deleted upon closing the web browser.

These same concepts could also work with a shopping cart, using session keyu to
update correct cart, and have it persist through time.

---- EVEN if not a logged in user can store cart info in the cookie, then when
they do log in that info can be carried into a new cart. or upon creating an
account.

---Considerations
- cant use diff devices if using cookies, so better to ahve on server side. also
if you wanted analyticas, cant look at carts if not on server.
- if you just use cookies, may not need db, just persist via cokies.

In ruby session[:session_id] or flash[:info], or flash.now[:key]
- session and flash just store a hash of kv pais, so can name our key anything
and point to what we want to save there session[:session_id] = X

-------------------------------------------------------------
SESSION ----- CONTROLLERS AND STATE - deomo in link
see - https://guides.rubyonrails.org/action_controller_overview.html#session
--------------------------------------------------------------
Your application has a session for each user in which you can store small amounts
 of data that will be persisted between requests. The session is only available
  in the controller and the view and can use one of a number of different storage
   mechanisms:

ActionDispatch::Session::CookieStore - Stores everything on the client.
ActionDispatch::Session::CacheStore - Stores the data in the Rails cache.
ActionDispatch::Session::ActiveRecordStore - Stores the data in a database using
Active Record. (require activerecord-session_store gem).
ActionDispatch::Session::MemCacheStore - Stores the data in a memcached cluster
 (this is a legacy implementation; consider using CacheStore instead).

All session stores use a cookie to store a unique ID for each session (you must
   use a cookie, Rails will not allow you to pass the session ID in the URL as
   this is less secure).

--- Accessing the Session
In your controller you can access the session through the session instance method.

To remove something from the session, set it to nil:

Rails does much of the work of implementing the session for us. Because our
controllers inherit from ApplicationController, which in turn inherits from
ActionController::Base, we can use the ActionController::Base#session method in
our controllers to get a hash-like object where we can retrieve and set state
(e.g. session[:user_id] = @user.id). When we call render or redirect, Rails will
 take the contents of the session hash and store it in the cookie.

 In summary:
 cookies persist for multiple sessions in session
 redirect_to --> makes second, separate request --> flash --> values stored for
 current AND next request
 render --> responds to current request --> flash.now --> values stored for
 current request only
-----------NOTE!
One limitation: A cookie's value can only be a string. You're responsible for
any serialization (usually to JSON) or deserialization that needs to happen. With
session, Rails will do that extra work for you so that you can store other data
types like arrays and hashes.

---------------------------------------------------------------------
--------------VALIDATIONS
https://open.appacademy.io/learn/full-stack-online/rails/displaying-validation-errors--flash
--------------------------------------------------------------------
Validation
For sundry reasons, data saved to the database need to be validated. Model level
 validations are the most common, but validations can be created on the client
 side in JavaScript, or controller level validations. Database constraints can
  also be added to the database to prevent bad input.

Performing the validations at the model level has these benefits:

Database agnostic
Convenient to test and maintain
Nice, specific, per-field error messages
Avoids reliance on database constraints (which throw nasty errors)
ActiveRecord::Base instance methods that run validations:

#create
#create!
#save
#save!
#update
#update_attributes
#update_attributes!

class User < ApplicationRecord
  validates :username, :password, presence: true
  validates :password, length: { minimum: 6 }
end

require 'bcrypt'
# => true
password_hash = BCrypt::Password.create('my_secret_password')
# => "$2a$10$sl.3R32Paf64TqYRU3DBduNJkZMNBsbjyr8WIOdUi/s9TM4VmHNHO"
password_hash.is_password?('my_secret_password')
# => true
password_hash.is_password?('not_my_secret_password')
# => false
