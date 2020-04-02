Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cats do
    # /cats/:cat_id/toys
    #this is up here, because it will be different for each individual cat, so nest it
    #that way we grab the toys for each individual cat based on id in url'
    resources :toys, only: [:index]

    #Note, dotn nest 2 levels deep, like memories for toys, would get weird url /cats/:cat_id/toys/memories  <--makes no sense
    # Would be better to put down below resources in a new do loop.
  end
  # /toys/:id
  #With these ones, we can put the id in the body, instead of the url, instead of seperating
  #Now we can just have a simple url, and include all info in the bdoy
  resources :toys, only: [:show, :update, :create, :destroy] # do
  # resouces :memories, only :index   -------------From example above about memories
  #end
end
