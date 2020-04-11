class CatsController < ApplicationController

  def index
    @cats = Cat.all

    render :index
  end

  def show
    @cat = Cat.find(params[:id])

    unless @cat
      # return user to inmdex page if not found
      redirect_to cats_url
      return
    end

    render :show
  end

  def new

  end
end
