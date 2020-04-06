class ArtworksController < ApplicationController
  # For this project, do not write any authentication or
  #     authorization logic. When creating a new artwork, require the
  #     uploader submit their artist_id. This isn't secure because anyone
  #     could always take your artist_id and upload new artworks in your name.
  #     For now, let's assume the users of our service aren't malicious :-)
  def index
    #GET /artworks
    render json: Artwork.all
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

  def artwork_params
    params.require(:artwork).permit(:title, :image_url, :artist_id)
  end
end
