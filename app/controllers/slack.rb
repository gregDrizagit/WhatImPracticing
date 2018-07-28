class SlackController < ApplicationController

    def event_receiver

        response_text = parse_text(params['text'])
        
        send_response(response_text)
        
    end

    def parse_text(text)

        response_text = ''

        case text
            when text.includes('add')
                response_text = 'Okay, how long did you practice today'
            when text.includes('edit')
                response_text = 'what do you want to edit'
            when text.includes('delete')
                response_text = 'what do you want to delete'
            else
                response_text = "I don't know what that means. Say something that I know what it means."
        end

        response_text
        
    end

    def send_response(res)
        url = 'https://hooks.slack.com/services/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'
        data =  res.to_json
        response = RestClient.post(url, data, :content_type => :json)
    end


end