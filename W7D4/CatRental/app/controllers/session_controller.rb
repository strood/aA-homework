class SessionController < ApplicationController
  # Requires no user to be logged in if going to create or new pages
  before_action :require_no_user!, only: [:create, :new]

  def new
    # sends us to a log in page to enter credentials
    render :new
  end

  def create
    # password is verified in this call to be correct.
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user.nil?
      # COuld do more here to redirect to create user
      render plain: "Credentials were incorrect"
      #  Will add an error to flash and redirect and display error later
    else
      # We now need to reset the users session token, update the session[] hash w/
       # new one so rails, and user session on same page
       # Will refactor out into login method, but for now will do here
      # login!(user)
      # user.reset_session_token
      # session[:session_token] = user.session_token
      # redirect_to cats_url
      #Refactor:
      login_user!(user)
      redirect_to cats_url
    end

  end

  def destroy
    # User helper method to find if current user active
    # if current_user
    #   # if current user, reset their session token so nobody
    #   # can hijack the session. then reset the browser side too
    #   user = current_user
    #   #Resetting users
    #   user.reset_session_token!
    #   #resetting browsers
    #   session[:session_token] = nil
    #
    # end
    # Refactored into application controllers
    logout_user!
    redirect_to new_session_url
  end

end
