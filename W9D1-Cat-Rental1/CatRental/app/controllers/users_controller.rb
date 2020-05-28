class UsersController < ApplicationController
  # Requires no user to be logged in if going to create or new pages
  before_action :require_no_user!, only: [:create, :new]
  before_action :require_user_is_current_user!, only: [:show]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # login!(@user)
      login_user!(@user)
      email = UserMailer.welcome_email(@user)
      email.deliver_now    #There are othe roptions beyond now, it can be sent at diff times. 
      redirect_to cats_url
    else
      #  Wil add in error to flash here
      redirect_to new_user_url, flash: { error_message: "Invalid Credentials"}
    end
  end

  def show
    @user = User.find(params[:id])

    unless @user && @user == current_user
      # if invalid user, or not the current user, redirect to index
      redirect_to cats_url
      return
    end
    # if its the current user viewing their own page, render
    render :show
  end

  private

  def user_params
    params.require(:user).permit(:password, :user_name)
  end
end
