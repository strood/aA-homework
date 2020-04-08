class CollectionsController < ApplicationController
  def index
    # GET    /users/:user_id/collections(.:format)
    # return all collections for given user
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
    if collection.destroy!
      render json: collection
    else
      render json: collection.errors.full_messages, status: :unprocessable_entity
    end
  end

  def add_artwork
    artwork_collection = ArtworkCollection.new(artwork_id: params[:artwork_id], collection_id: params[:collection_id])

    if artwork_collection.save!
      redirect_to "/collections/#{params[:collection_id]}/artworks"
    else
      render json: artwork_collection.errors.full_messages, status: :unprocessable_entity
    end
  end

  def remove_artwork
    artwork_collection = ArtworkCollection.find_by(collection_id: params[:collection_id], artwork_id: params[:artwork_id])

    if artwork_collection.destroy!
      redirect_to "/collections/#{params[:collection_id]}/artworks"
    else
      render json: artwork_collection.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def collections_params
    params.require(:collection).permit(:name, :user_id)
  end
end
