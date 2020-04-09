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

  def create
    # Shouldnt pass in raw params data to model, filtrer through the book_params
    @book = Book.new(book_params) #This line creates a model level instance that we can then access from the pages we render, or gets us url redirects ect

    if @book.save!
      # show user the book show page
      redirect_to book_url(@book)
    else
      # redirect back to the book form, save the info with tags on the new html page
      render :new
    end
  end

  def new
      @book = Book.new
      render :new
  end

  def edit
    @book = Book.find_by(id: params[:id] )
    render :edit
  end

  def update
    @book = Book.find_by(id: params[:id])

    if @book.update_attributes(book_params)
      redirect_to book_url(@book)
    else
      render :edit
    end
  end

  private
  def book_params
    params.require(:book).permit(:title, :author, :year, :category, :description)
  end
end
