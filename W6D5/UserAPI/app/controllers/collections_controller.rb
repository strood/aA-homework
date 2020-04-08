class CollectionsController < ApplicationController
  def index
    # GET    /users/:user_id/collections(.:format)
    render json: User.find(params[:user_id]).collections
  end

  def create
    # POST   /collections(.:format)
    collection = Collection.new(collections_params)

    if collection.save!
      render json: collection
    else
      render json: collection.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    #  GET    /collections/:id(.:format)
    collection = Collection.find(params[:id])
    render json: collection
  end

  def destroy
    # DELETE /collections/:id(.:format)
    collection = Collection.find(params[:id])
    if collection.destory!
      render json: collection
    else
      render json: collection.errors.full_messages, status: :unprocessable_entity
    end
  end

  def collections_params
    params.require(:collecton).permit(:name, :user_id)
  end
end
