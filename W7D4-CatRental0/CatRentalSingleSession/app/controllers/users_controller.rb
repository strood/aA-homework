class UsersController < ApplicationController
  # Requires no user to be logged in if going to create or new pages
  before_action :require_no_user!, only: [:create, :new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # login!(@user)
      login_user!(@user)
      redirect_to cats_url
    else
      #  Wil add in error to flash here
      redirect_to new_user_url, flash: { error_message: "Invalid Credentials"}
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :user_name)
  end
end
