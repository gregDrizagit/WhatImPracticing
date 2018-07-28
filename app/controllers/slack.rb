class SlackController < ApplicationController

    def event_receiver

        response_text = parse_text(params['event']['text'])
        
        send_response(response_text)

    end

    def parse_text(text)
        
        response_text = ""

        downcase_text = text.downcase

    
        if downcase_text.include? 'add'
            response_text = "Cool how long did you practice"
        elsif downcase_text.include? 'delete'
            response_text ="What do you want to delete"
        elsif downcase_text.include? "edit"
            response_text = "what do you want to edit"
        else
            response_text = "I don't know what that means. Say something that I know what it means."
        end

        response_text
        
    end

    def send_response(res)
        url = 'https://hooks.slack.com/services/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'
        data = {text: res}.to_json
        response = RestClient.post(url, data, :content_type => :json)
    end


end