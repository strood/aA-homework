Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: [:new, :create, :show]

  #NOTE!!! USe resource for sessions as we only want user to ahve one!!!!
  # This means several things:
    # 1. a user can only be logged in on one device at a time
    # 2. we do not need a table for session
    # 3. when we create and destroy a session, we do not need to provide an id
    # 4. the routes will look like this:

    # GET      /session/new   sessions#new
    # POST     /session       sessions#create
    # DELETE   /session       sessions#destroy
  
  resource :session, only: [:new, :create, :destroy]

end
