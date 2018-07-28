class SlackController < ApplicationController

    def helloworld

        url = 'https://hooks.slack.com/services/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'
        data =  {"text":'hello world'}.to_json
        response = RestClient.post(url, data, :content_type => :json)
    end


end