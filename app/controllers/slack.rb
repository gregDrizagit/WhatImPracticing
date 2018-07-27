class SlackController < ApplicationController
    require 'rest-client'

    def helloworld

        
        RestClient.post('https://hooks.slack.com/services/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', data:{"text":"Hello, World!"}, {
        'Content-type: application/json' }
        )

    end
end