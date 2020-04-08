class ArtworksController < ApplicationController
  # For this project, do not write any authentication or
  #     authorization logic. When creating a new artwork, require the
  #     uploader submit their artist_id. This isn't secure because anyone
  #     could always take your artist_id and upload new artworks in your name.
  #     For now, let's assume the users of our service aren't malicious :-)
  def index
    # called through :users :artworks,:index - listing all artworks owned by a user
    # OR GET    /collections/:collection_id/artworks(.:format)
    #   and shared with a user

    if params[:collection_id]
      render json: Artwork.artworks_for_collection_id(params[:collection_id])
    else
      render json: Artwork.artworks_for_user_id(params[:user_id])
    end
  end

  def create
    #post /artworks
    # as it doesnt authenticate that i am artist_id = x, anyone can upload as
    # that user just by passing their artist ID. Allowing somone to imposter
    artwork = Artwork.new(artwork_params)

    if artwork.save!
      render json: artwork
    else
      render json: artwork.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    #GET /artwork/:id
    artwork = Artwork.find(params[:id])
    render json: artwork
  end

  def update
    # PUT or PATCH /artworks/:id
    artwork = Artwork.find(params[:id])

    if artwork.update(artwork_params)
      render json: artwork
    else
      render json: artwork.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    #DELETE /artworks/:id
    artwork = Artwork.find(params[:id])

    if artwork.destroy!
      redirect_to "/artworks"
    else
      render json: artwork.errors.full_messages, status: :unprocessable_entity
    end
  end

  def like
    like = Like.new(user_id: params[:user_id], imageable_id: params[:id], imageable_type: "Artwork")
    if like.save!
      render json: like
    else
      render json: like.errors.full_messages, status: :unprocessable_entity
    end
  end

  def unlike
    like = Like.find_by(user_id: params[:user_id], imageable_id: params[:id], imageable_type: "Artwork")

    if like.destroy!
      render json: like
    else
      render json: like.errors.full_messages, status: :unprocessable_entity
    end
  end

  def favorite
    # POST   /artworks/:id/favorite(.:format)
    artwork = Artwork.find(params[:id])
    artwork.favorite = true
    if artwork.save!
      render json: artwork
    else
      render json: artwork.error.full_messages, status: :unprocessable_entity
    end
  end

  def unfavorite
    # POST   /artworks/:id/unfavorite(.:format)
    artwork = Artwork.find(params[:id])
    artwork.favorite = false
    if artwork.save!
      render json: artwork
    else
      render json: artwork.error.full_messages, status: :unprocessable_entity
    end
  end

  private

  def artwork_params
    params.require(:artwork).permit(:title, :image_url, :artist_id)
  end
end
