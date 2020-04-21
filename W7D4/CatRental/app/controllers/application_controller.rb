class ApplicationController < ActionController::Base
  # REMOVE THIS FOR PRODUCTION< JUST BAVOIDS US HAVING AUTHENTICITY ISSUES WHNE TESTING
  skip_before_action :verify_authenticity_token

  #This line makes it available in our views too, by default it is
  # available in our other controllers.
  # Expose current_user method to the views
  helper_method :current_user
  helper_method :logged_in?

  private

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !current_user.nil?
  end

  def login_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout_user!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def require_no_user!
    redirect_to cats_url if current_user
  end

  def require_user!
    redirect_to new_session_url if current_user.nil?
  end

end
