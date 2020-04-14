class CatRentalRequestsController < ApplicationController
  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)

    if @cat_rental_request.save!
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :new
    end
  end

  def approve
    @cat_rental_request = current_cat_rental_request

    if @cat_rental_request.approve!
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :show
    end
  end

  def deny
    @cat_rental_request = current_cat_rental_request

    if @cat_rental_request.deny!
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :show
    end
  end

  private

  def current_cat_rental_request
    @cat_rental_request ||=
        CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
      current_cat_rental_request.cat
  end
  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
