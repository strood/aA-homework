class CommentsController < ApplicationController
  def index
    # called through GET    /artworks/:artwork_id/comments(.:format)
    # OR GET    /users/:user_id/comments(.:format)
    # filter vbasded on where tis coming from and retrurn correct list of comments

    if params[:user_id]
      render json: User.find(params[:user_id]).comments
    elsif params[:artwork_id]
      render json: Artwork.find(params[:artwork_id]).comments
    else
      render plain: "Error returning comments"
    end
  end

  def create
    # POST /comments(.:format)
    comment = Comment.new(comment_params)

    if comment.save!
      render json: comment
    else
      render json: comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    #  DELETE /comments/:id(.:format)
    comment = Comment.find(params[:id])

    if comment.destroy!
      render json: comment
    else
      render json: comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :user_id, :artwork_id)
  end
end
