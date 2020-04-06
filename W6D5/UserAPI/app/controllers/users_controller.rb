class UsersController < ApplicationController
  # The key method here is #params. #params is a method provided by
  #  ActionController::Base that returns a hash of all the parameters
  #  available. The parameters are complied by the router and are
  #  sourced from three places:

  # Route parameters (e.g. the :id from /users/:id)
  # Query string (the part of the URL after the ?: ?key=value)
  # POST/PATCH request data (the body of the HTTP request).

  def index
    # GET /users
    # returns our users in JSON format
    render json: User.all
  end

  def create
    # POST /users
    # We will create a new user with the submitted info

    user = User.new(user_params)

    if user.save!
      render json: user
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    # GET /users/:id
    #render json: params
    # could also render just :id with params[:id]

    user = User.find(params[:id])
    #automatically returns nice looking error message if not found
    render json: user
  end

  def update
    # PATCH /users/:id
    # PUT /users/:id
    # Update contents of a user, allow editing of both name and email

    user = User.find(params[:id]) #Will auto catch if no user found

    if user.update(user_params)
      render json: user
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    # DELETE /users/:id
    # delte the given user, redirect to list of userrs pagfe if
    user = User.find(params[:id])

    if user.destroy!
      redirect_to "/users"
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end

  #   Nesting Parameters
  # Notice how all of our parameters come in at the top level of the
  # parameters hash. Let's say we wanted to structure it a bit
  #  differently so that certain parameters came in nested under
  #  others (hash within a hash) like so:

  # {
  #   'id': 5,
  #   'some_category': {
  #     'a_key': 'another value',
  #     'a_second_key': 'yet another value',
  #     'inner_inner_hash': {
  #       'key': 'value'
  #     }
  #   },
  #   'something_else': 'aaahhhhh'
  # }
  # Here's how we would accomplish that:

  # <!-- in Postman's "Body" tab: --> form-data tab in body
  # some_category[a_key]: 'another value'
  # some_category[a_second_key]: 'yet another value'
  # some_category[inner_inner_hash][key]: 'value'
  # something_else: 'aaahhhhh'

  # <!-- in the query string -->
  # '/users?some_category[a_key]=another+value&some_category[a_second_key]=yet+another+value'

  # <!-- ...etc. -->

end
