class SlackController < ApplicationController

    def event_receiver

        if params['event']['type'] == "app_mention"

            response_text = parse_text(params['event']['text'])
            send_response(response_text)

            puts "APP MENTION"

        elsif params['event']['type'] == "interactive_message"
            puts "INTERACTIVE MESSAGE"
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

    def open_add_dialogue 
    # open_dialogue = {
    #     "trigger_id": "13345224609.738474920.8088930838d88f008e0",
    #     "dialog": {
    #         "callback_id": "ryde-46e2b0",
    #         "title": "Request a Ride",
    #         "submit_label": "Request",
    #         "notify_on_cancel": true,
    #         "elements": [
    #             {
    #                 "type": "text",
    #                 "label": "Pickup Location",
    #                 "name": "loc_origin"
    #             },
    #             {
    #                 "type": "text",
    #                 "label": "Dropoff Location",
    #                 "name": "loc_destination"
    #             }
    #         ]
    #     }
    # }
    end

    def add_trigger
        dialogue = {
            "text": "Add practice routine/",
            "attachments": [
                {
                    "fallback": "You are unable to choose a game",
                    "callback_id": "wopr_game",
                    "color": "#3AA3E3",
                    "attachment_type": "default",
                    "actions": [
                        {
                            "name": "Add",
                            "text": "What did you practice today?",
                            "type": "button",
                            "value": "Add"
                        }

                    ]
                }
            ]
        }

        

    end

    def add_session()
        Session.add()
    end

    def send_response(res)
        url = 'https://hooks.slack.com/services/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'
        data = res.to_json
        response = RestClient.post(url, data, :content_type => :json)
    end


end