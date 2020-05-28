class ApplicationController < ActionController::Base

# REMOVE THIS FOR PRODUCTION< JUST BAVOIDS US HAVING AUTHENTICITY ISSUES WHNE TESTING
skip_before_action :verify_authenticity_token
end
