class SlackController < ApplicationController

    def helloworld
        puts params['payload']

        if params['payload'] 
            render json: params["payload"], status: 200
        else
            render json:{}, status: 200
        end
    end
end