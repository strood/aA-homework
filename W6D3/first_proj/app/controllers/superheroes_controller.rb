class SuperheroesController < ApplicationController
  def index
    # Sample request: This just ex, doesnt wokr here
    #
    # GET /clients?status=activated
    # we normally leave out the `self.` part of `self.params`
    # if self.params[:status] == "activated"
    #   @clients = Client.activated
    # else
    #   @clients = Client.unactivated
    # end

    render json: Superhero.all
  end

  def show
    superhero = Superhero.find_by(id: params[:id])

    render json: superhero
  end

  def create
    superhero = Superhero.new(superhero_params)

    if superhero.save
      render json: superhero
    else
      render json: superhero.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    superhero = Superhero.find_by(id: params[:id])

    if superhero.update(superhero_params)
      render json: superhero
    else
      render json: superhero.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    superhero = Superhero.find_by(id: params[:id])

    if superhero.destroy
      render json: superhero
    else
      render json: "Can't destroy a superhero, they are too strong"
    end
  end

  private

  def superhero_params
    params.require(:superhero).permit(:name, :secret_identity, :power)
  end
end
