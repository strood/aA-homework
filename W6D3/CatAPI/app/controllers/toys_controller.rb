class ToysController < ApplicationController
  def index
    # /cats/:cat_id/toys
    cat = Cat.find(params[:cat_id])
    render json: cat.toys
  end

  def show
    # /cats/:cat_id/toys/:id
    # prefer to ahve /toys/:id
    render json: Toy.find(params[:id])
  end

  def destroy
    # /toys/:id
    toy = Toy.find(params[:id])
    toy.destroy
    render json: toy
  end

  def update
    # /toys/:id
    toy = Toy.find(params[:id])

    if toy.update(params[:toy].permit(:name))
      render json: toy
    else
      render json: toy.errors.full_messages, status: :unprocessable_entity
    end
  end

  def create
    # POST /toys

    # params => Parameters < HashWIthIndiffferentAccess < Hash
    toy = Toy.new(toy_params)

    if toy.save
      render json: toy
    else
      render json: toy.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def toy_params
    params.require(:toy).permit(:cat_id, :name, :ttype)
  end
end
