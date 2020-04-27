Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :cats, only: [:index, :show, :new, :create, :edit, :update]

  resources :cat_rental_requests, only: [:new, :create] do
    member do
      post 'approve'
      post 'deny'
    end
  end

  resources :users, only: [:new, :create, :show]

  # A visitor to your site implicitly has their own session (it's stored in their browser),
  # so there's no need to create routes for different sessions. Only new, create, and destroy are needed.
  resources :session, only: [:new, :create, :destroy]

  root to: redirect('/cats')
end
