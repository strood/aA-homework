Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :users     #Commented out so we could see how to do individually below:
  # get "/users", to: "users#index", as: "users"
  # post "/users", to: "users#create"
  # get "/users/new", to: "users#new", as: "new_user"
  # get "/users/:id/edit", to: "users#edit", as: "edit_user"
  # get "/users/:id", to: "users#show", as: "user"
  # patch "/users/:id", to: "users#update"
  # put "/users/:id", to: "users#update"
  # delete "/users/:id", to: "users#destroy"

  # Old method above, below we limit with only, generate PUT and PATCH w/ :update.
  #  we want. See CatAPI for further nesting in W6D3.

  resources :users, only: [:index, :create, :show, :update, :destroy] do
    member do
      resources :artworks, only: [:index]
      resources :comments, only: [:index]
      resources :collections, only: [:index]
    end
  end

  resources :comments, only: [:index, :create, :destroy] do
    member do
      post :like, to: "comments#like", as: "like"
      post :unlike, to: "comments#unlike", as: "unlike"
    end
  end

  # TAKE NOTE OF HOW THIS IS WRITTEN< CAN WRITE ALL LIKE THIS
  resources :artworks, only: [:create, :show, :update, :destroy] do
    member do
      resources :comments, only: [:index]
      post :like, to: "artworks#like", as: "like"
      post :unlike, to: "artworks#unlike", as: "unlike"
      post :favorite, to: "artworks#favorite", as: "favorite"
      post :unfavorite, to: "artworks#unfavorite", as: "unfavorite"
    end
  end

  resources :artwork_shares, only: [:create, :destroy] do
    member do
      post :favorite, to: "artwork_shares#favorite", as: "favorite"
      post :unfavorite, to: "artwork_shares#unfavorite", as: "unfavorite"
    end
  end

  resources :collections, only: [:create, :show, :destroy] do
    resources :artworks, only: [:index] do
      post :add, to: "collections#add_artwork", as: "add"
      post :remove, to: "collections#remove_artwork", as: "remove"
    end
  end

  # root to: ("/users")
end
