class SlackController < ApplicationController

    def helloworld
        render json: params[:payload] 
    end
end