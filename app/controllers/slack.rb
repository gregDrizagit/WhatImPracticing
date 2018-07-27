class SlackController < ApplicationController

    def helloworld
        puts params['payload']
        render json: params["payload"] 
    end
end