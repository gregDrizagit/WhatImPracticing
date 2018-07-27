class SlackController < ApplicationController

    def helloworld

        url = 'https://hooks.slack.com/services/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'
        data =  {"text":'hello world'}.to_json
        response = RestClient.post(url, data, :content_type => :json)
        puts params
    end


end