class ApplicationController < ActionController::Base

  #To be able to use these helper methods throughout any view, we should use helper_method
  #This will make current_user available in all views.
  helper_method :current_user


  # protect the users#show page so that only the user themselves can view their own show.
  def require_current_user!
    redirect_to new_session_url if current_user.nil?
  end

  #Helper methods so we can hold session token in session, along wit user storing a copy
  def login!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def current_user
    return nil if session[session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

# Notice that in logout! we reset the session token. This will invalidate the
  # old session token. We want to do that in case anyone has managed to steal
  # the token; this will deny the thieves further access to the account.
  def logout!
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

end
