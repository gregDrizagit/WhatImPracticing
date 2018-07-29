class SlackController < ApplicationController
    include Slackable
    
    def event_receiver

        if params['event'] # did we get an event message or a payload

            if params['event']['type'] == "app_mention" # if we got an app mention 

                response_text = parse_text(params['event']['text']) #see what the message was
                send_response(response_text) #send the response

            end

        elsif params['payload']

                json = JSON.parse(params["payload"])
                if json['type'] == "interactive_message"
                    dialogue = open_add_dialogue(json['trigger_id'])
                    send_dialogue(dialogue)
                elsif json['type'] == "dialog_submission"

                end
        end
        
    end

    def parse_text(text)
        
        response_text = ""

        downcase_text = text.downcase

        if downcase_text.include? 'add'
            response_text = add_trigger()
        elsif downcase_text.include? 'delete'
            response_text ="What do you want to delete"
        elsif downcase_text.include? "edit"
            response_text = "what do you want to edit"
        else
            response_text = "I don't know what that means. Say something that I know what it means."
        end

        response_text
        
    end

  
    def add_session()
        # Session.add()
    end

    def parse_dialogue
    end

    def send_response(res)
        url = 'https://hooks.slack.com/services/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'
        data = res.to_json
        response = RestClient.post(url, data, {:content_type => :json, :accept => :json})
    end

    def send_dialogue(dialogue)
        puts 'sent dialouge!!!!!!!!!!!!!!!!!!!'
        token = 'Bearer xoxb-406277854996-406582689938-SNKLIUU3erryz00MrZDGdOl3'
        url = 'https://slack.com/api/dialog.open'
        data = dialogue.to_json
        headers = {
            :content_type => :json, 
            :Authorization => token,
        }
        response = RestClient.post(url, data, headers)
        puts response
    end


end