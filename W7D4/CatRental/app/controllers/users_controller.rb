class UsersController < ApplicationController

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
      render json: user_params
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :user_name)
  end
end
