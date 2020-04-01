class SillyController < ApplicationController
  def fun
    # OG response:
    # render text: "Hey there!"

    #new respo:
    render json: params

    # gives me :
    # {
    #     "controller": "silly",
    #     "action": "fun"
    # }
    # ^ That is the reposnse i get it postman. given GET localhost:3000/silly

    #  If i add more to the request i send, GET localhost:3000/silly?message="Hi!"
    #  params returned as:
    # {
    #     "message": "\"Hi!\"",
    #     "controller": "silly",
    #     "action": "fun"
    # }

    #  If i add more to the request i send, GET localhost:3000/silly?message="Hi!"&fun=100
    # {
    #     "message": "\"Hi!\"",
    #     "fun": "100",
    #     "controller": "silly",
    #     "action": "fun"
    # }

    # !!!!

    # can get a more specifically chosen response if we efit our render line to something like:

    # render json: params[:message]

    #Treat params as a hash and can get kv pairs from it based on the stuff passed in the query string, or other parts of header.

    # if passed params, like the /:id after trhe controller.
    # params is a has like object containing 3 things:
    # 1) Query string
    # 2) Request body
    # 3) URL params/route params (wildcards)
  end

  def time
    skip_before_action :request_forgery_protection
    render json: params
  end

  def super
    render json: params
  end
end
