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

    cat = Cat.new(cat_params)
    cat.admin = false

    if cat.save
      render json: cat
    else
      render json: cat.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    # ...
    #Cant shouldnt eb able to update self to become admin...
    cat = Cat.find(params[:id])
    # if i upload an admin attribute, this tries to set
    # cat.admin, but i dont want this

    cat.update(params[:cat])
  end

  def destroy
    # ...
    # if !curren_cst_user.admin
    #     raise "error"
    # end
  end

  def cat_params
    params.require(:cat).permit(:name)
  end
end
