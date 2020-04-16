class UsersController < ApplicationController
  # Important line below, makes sure we can only access if a session active.
  before_action :require_current_user!, except: [:create, :new]
  # A rule of before_action is that, if in the process of running a filter
  # redirect_to is called, the action method will not be called. For instance,
  # if a user tries to visit the users#show page without having logged in first,
  # the callback will issue a redirect, and Rails will forgo calling the
  # UsersController#show method.
  before_action :require_correct_current_user, except: [:create, :new]

  #custom filter to make sure user A cant loook at user B show page
  def require_correct_current_user!
    # Think this is correct, have not confirmed, will have to try out in proj
    redirect_to new_session_url if current_user.id != params[:id]
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      render json: @user.errors.full_messages
    end
  end

  def new
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end


end
