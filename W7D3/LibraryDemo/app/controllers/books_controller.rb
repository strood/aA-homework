class BooksController < ApplicationController
  def index
    # GET /book
    @books = Book.all
    # render json: Book.all
    render :index
  end

  def show
    # GET /book/:id
    @book = Book.find_by(id: params[:id])

    unless @book
      # return user to inmdex page if not found
      redirect_to books_url
      return 
    end

    render :show


  end
end
