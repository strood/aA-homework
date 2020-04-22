class CatRentalRequestsController < ApplicationController
  before_action :require_user!, only: [:new, :create, :approve, :deny]
  before_action :require_owns_cat!, only: [:approve, :deny]

  def new
    @rental_request = CatRentalRequest.new(cat_id: params[:cat_id])
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)

    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:error_message] = @rental_request.errors.full_messages
      render :new
    end
  end

  def approve
    @rental_request = current_cat_rental_request

    if @rental_request.approve
      redirect_to cat_url(current_cat)
    else
      flash.now[:error_message] = @rental_request.errors.full_messages
      redirect_to cat_url(current_cat), flash: { error_message: 'Request cannot overlap approved request' }
    end
  end

  def deny
    @rental_request = current_cat_rental_request

    if @rental_request.deny!
      redirect_to cat_url(current_cat)
    else
      render :show
    end
  end

  private

  def current_cat_rental_request
    @rental_request ||=
        CatRentalRequest.includes(:cat).find(params[:id])
  end

  def require_owns_cat!
    redirect_to cat_url(current_cat) unless current_user.owns_cat?(current_cat)
  end

  def current_cat
      current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
