class ArtworkSharesController < ApplicationController
  # This is a joins table, so while RESTful design patterns still apply, this controller
  #  will look a bit dirrerent than the others, as we will only need to share and
  # unshare artworks. Just build associated controller acions.

  def create
    #POST /artwork_shares
    # create a new share, between a viewer and an artwork
    artwork_share = ArtworkShare.new(params.require(:artwork_share).permit(:user_id, :artwork_id))

    if artwork_share.save!
      render json: artwork_share
    else
      render json: artwork_share.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    # DELETE /artwork_shares/:id
    #unshares an artwork from a viewer
    artwork_share = ArtworkShare.find(params[:id])

    if artwork_share.destroy!
      render json: artwork_share
    else
      render json: artwork_share.errors.full_messages, status: :unprocessable_entity
    end
  end
end
