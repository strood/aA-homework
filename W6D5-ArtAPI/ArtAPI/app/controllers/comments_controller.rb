class CommentsController < ApplicationController
  def index
    # called through GET    /artworks/:artwork_id/comments(.:format) - return art comments
    # OR GET    /users/:user_id/comments(.:format) - return suer comments
    # Or GET   /comments(.:format)  - return all
    # filter vbasded on where tis coming from and retrurn correct list of comments
    #NOTE!!!  does not grab from URL, must submit user_id or artwork_id as json param
    if params[:user_id]
      render json: User.find(params[:user_id]).comments
    elsif params[:artwork_id]
      render json: Artwork.find(params[:artwork_id]).comments
    else
      render json: Comment.all
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

  def like
    # POST   /comments/:id/like
    like = Like.new(user_id: params[:user_id], imageable_id: params[:id], imageable_type: "Comment")

    if like.save!
      render json: like
    else
      render json: like.errors.full_messages, status: :unprocessable_entity
    end
  end

  def unlike
    # POST   /comments/:id/unlike
    like = Like.find_by(user_id: params[:user_id], imageable_id: params[:id], imageable_type: "Comment")

    if like.destroy!
      render json: like
    else
      render json: like.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :artwork_id)
  end
end
