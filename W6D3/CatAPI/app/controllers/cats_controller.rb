class CatsController < ApplicationController
  def index
    # GET /cats
    # cats = Cat.all #pull all cats
    # render json: cats #Return in a json format
    #Above made into one line
    render json: Cat.all
  end

  def show
    # GET /cats/:id
    # cats = Cat.find(params[:id])
    # render json: cats
    render json: Cat.find(params[:id])
  end

  def create
    # POST /cats - create a new cat
    # Content-length: ...
    #
    # {body injson format} = {"cat": {"name": "Sally"}, "dog": { "name": "Bertrand"} }
    cat = Cat.new(name: params[:cat])
    if cat.save
      render json: cat
    else
      render json: cat.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    # ...
  end

  def destroy
    # ...
  end

  def cat_params
    params.require(:cat).permit(:name)
  end
end
