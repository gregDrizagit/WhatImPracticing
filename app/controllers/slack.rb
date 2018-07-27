class SlackController < ApplicationController

    def helloworld
        puts params['payload']
        render json: params["payload"], status: 200
    end
end