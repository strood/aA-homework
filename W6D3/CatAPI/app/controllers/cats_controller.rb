class CatsController < ApplicationController
  def index
    # GET /cats
    # cats = Cat.all #pull all cats
    # render json: cats #Return in a json format
    #Above made into one line

    #Set and instance variable to access this data from a request in teh view, without @ it would be
    # local variable and not be available in the view
    @cats = Cat.all
    render :index  #This translates to "index.html"
  end

  def show
    # GET /cats/:id
    # cats = Cat.find(params[:id])
    # render json: cats
    # render json: Cat.find(params[:id])
    @cat = Cat.find(params[:id])
    render :show
  end

  #   1. GET request for cat/new form
  #   2. POST to /cats
  #  3. validation fails if i have extra stuff, or not enough
  #   4. Server render the new template again
  # 5. keeps the values filled in from submit, so dont need refill
  #

  # BEFORE THE BELOW HAPPENED
  #   5. Client makes GET request gfor /cats/new
  #   6. client gets a blank form (WE DONT WANT THIS)
  # WE WANT TO SAVE DATA FROM FORM IF IT DOESNT GO THROUGH

  def create
    # POST /cats - create a new cat
    # Content-length: ...
    #
    # {body injson format} = {"cat": {"name": "Sally"}, "dog": { "name": "Bertrand"} }

    @cat = Cat.new(cat_params)

    # NOTE REDIRECT_TO USAGE HERE!
    if @cat.save
      # cat_url(@cat) == /cats/..
      redirect_to cat_url(@cat)
    else
      render :new
      #Old below: V
      #   render json: @cat.errors.full_messages, status: :unprocessable_entity
    end
  end

  #   notes for above.
  #   1. GET  /cats/new to fetch a form
  #   2. User fills out a form, slicks submit
  #   3. POST /cats the data in the form
  #   4. Create action invoked, cat created
  #   5. Send client a reditrect to /cats/#{id}
  #   6. Client makes a GET request for /cats/#{id}
  #   7. Show action for newly created cat is invoked.

  def new
    # show a form to create a new object
    # /cats/new
    @cat = Cat.new
    render :new
  end

  def edit
    #show a form to edit an existing cat
    # @/cats/:id/edit

  end

  def update
    # ...
    #Cant shouldnt eb able to update self to become admin...
    cat = Cat.find(params[:id])
    # if i upload an admin attribute, this tries to set
    # cat.admin, but i dont want this

    cat.update(params[:cat])
  end

  def destroy
    # ...
    # if !curren_cst_user.admin
    #     raise "error"
    # end

    @cat = Cat.find(params[:id])
    @cat.destroy
    redirect_to cats_url

    # 1. GET /cats
    # 2. click delete button
    # 3. Secnd POST /cats/123; but _method="DELETE" so rails knows
    # to destroy
    # 4. destroys cat. Isuues redirect to client
    # 5. Client GETs /cats again. Without deleted cat
  end

  def cat_params
    params.require(:cat).permit(:name, :skill)
  end
end
