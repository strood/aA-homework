Rails.application.routes.draw do

  # ######IMPORTANT!!! can use ato add line :
  # resources :silly   <-- or any model name
  # Aboive command will lay out whole outline of basics at RESTFUl standards.

  # This single line in config/routes.rb will generate a map of the following requests for URLs to a set of controller actions in the PhotosController.

  # HTTP Verb	Path	            action	used for
  # GET	      /photos     	    index	   display a list of all photos
  # GET	      /photos/new	       new	   return an HTML form for creating a new photo
  # POST	    /photos	          create	  upload and create a new photo
  # GET	      /photos/:id	       show	    display a specific photo
  # GET	      /photos/:id/edit 	edit	    return an HTML form for editing a photo
  # PATCH/PUT /photos/:id	     update     update a specific photo
  # DELETE	  /photos/:id	     destroy	  delete a specific photo

  #   Paths and Routing Helpers
  # Specifying a resource route will also create a number of routing helper methods that your controllers and views can use to build URLs. In the case of resources :photos:

  # method	url
  # photos_url	http://www.example-site.com/photos
  # new_photo_url	http://www.example-site.com/photos/new
  # photo_url(@photo)	http://www.example-site.com/photos/#{@photo.id}
  # edit_photo_url(@photo)	http://www.example-site.com/photos/#{@photo.id}/edit

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # This section will be written in a DSL(Domain Specific Language) to route the various routes
  #The reouter will readd this when trying to decide where to deliver the HTTP request it received.
  # ex:

  #HTTPMethName, 'path', to: "Controller#controller_action" <<---------IMPORTANT to follow this format

  # get "superheroes", to: "superheroes#index"
  # get "superheroes/:id", to: "superheroes#show"    VVVVVV Actually implemented belowVVVV
  # post "superheroes", to: "superheroes#create"
  # patch "superheroes/:id", to: "superheroes#update"
  # put "superheroes", to: "superheroes#update"
  # delete "superheroes/:id", to: "superheroes#destroy"

  # Sticking to RESTful principals, This standardizes standard responses for cretian http requests so ppl know what to expect
  # If superheroes is name resorce, then the superheroes controlled should ahve an index action to retrun full data set.
  #If we have a wildcard like "/:id", that should give you controller with show action, showing that particular wildcard
  # post should hit the controller#create action
  # patch - should hit the update action, as we are genrally amending
  # put "" -ditto above
  # delete should call controller#destroy as per conventinon

  # IF YOU FOLLOW THE RESTFUL principals above, you can just co this below:

  get "silly", to: "silly#fun"    #This is for our example,

  post "silly", to: "silly#time"

  get "silly/:id", to: "silly#super"

  #We test our API with POSTMAN extension in chrome

  # Can all be creates with ;
  # #recouces :superheroes, only: [:index, :show, :create, :update, :destroy] ##2 others we dont mention
  ##:new, :edit - not needed for our api yet

  # resources :superheroes do
  #   resources :abilities, only: [:index] - collection route
  # end
  # ^^^^^
  # get superheroes/2/abilities -> superman, with all his abilities (superhro 2 w/ abils)

  # resources :abilities, only: [:show, :update, :create, :destroy] -particular ability for a superhero
  #These ^ are not nested as above, next coillection routes, dont nest member routes.
  #id you already ahve ability id, you will be calling direct
  # patch 'superheroes/2/abilities/6' <--- if you have id, shoudl vbe able to make change without it. being specified as a superhero

  get "superheroes", to: "superheroes#index"
  get "superheroes/:id", to: "superheroes#show"
  post "superheroes", to: "superheroes#create"
  patch "superheroes/:id", to: "superheroes#update"
  put "superheroes", to: "superheroes#update"
  delete "superheroes/:id", to: "superheroes#destroy"
end
