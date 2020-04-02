class ApplicationController < ActionController::Base
  # This saves us from authenticity token error, take out
  # if actually launching live !!!!!!!!!!!!!!
  skip_before_action :verify_authenticity_token
end
