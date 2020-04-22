class CatsController < ApplicationController
    #Requires user to be logged in if going to create or edit pages
    # Note we also protect from POST request attacj on create
    # edit is the easiest and just UI related to protect.
    before_action :require_user!, only: [:new, :edit, :create, :update]
    before_action :require_owns_cat!, only: [:edit, :update]

  def index
    @cats = Cat.all

    render :index
  end

  def show
    @cat = Cat.find(params[:id])

    unless @cat
      # return user to inmdex page if not found
      redirect_to cats_url
      return
    end

    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    #Instead of using a hidden form field on the cat creation or edit pages
    # we use the current user here to update id.
    # if we did the form, or got user input, we would be vulnerable to attack
    # this way we know that since a user must be loggedf in to see _form
    # we can count on current user to be who we want to set teh cat to.
    # <input name="cat[user_id]" type="hidden" value="<%= current_user.id %>"> <<-- Vulnerable to somone inspecting and changing value
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:error_message] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat  = Cat.find(params[:id])
    unless @cat
      # return user to inmdex page if not found
      redirect_to cats_url
      return
    end

    render :edit
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:error_message] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def require_owns_cat!
    redirect_to cat_url(current_cat) unless current_user.owns_cat?(current_cat)
  end

  def current_cat
    Cat.find(params[:id])
  end

  def cat_params
    params.require(:cat).permit(:name,:birth_date,:sex,:color,:description)
  end
end
