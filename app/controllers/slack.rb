class SlackController < ApplicationController
    skip_before_action :verify_authenticity_token

    def helloworld
        puts params['payload']
        render json: params["payload"] 
    end
end