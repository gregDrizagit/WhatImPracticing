class SlackController < ApplicationController

    def event_receiver

        if params['event'] # did we get an event message or a payload

            if params['event']['type'] == "app_mention" # if we got an app mention 

                response_text = parse_text(params['event']['text']) #see what the message was
                send_response(response_text) #send the response

            end

        elsif params['payload']

            if params['payload']['type'] == "interactive_message"
                trigger_id = params['payload']['trigger_id']
                response_text = open_add_dialogue()
                send_dialogue(response_text, trigger_id)
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

    def open_add_dialogue 
        open_dialogue = {
            "trigger_id": "13345224609.738474920.8088930838d88f008e0",
            "dialog": {
                "callback_id": "ryde-46e2b0",
                "title": "Request a Ride",
                "submit_label": "Request",
                "notify_on_cancel": true,
                "elements": [
                    {
                        "type": "text",
                        "label": "Pickup Location",
                        "name": "loc_origin"
                    },
                    {
                        "type": "text",
                        "label": "Dropoff Location",
                        "name": "loc_destination"
                    }
                ]
            }
        }
    end

    def add_trigger
        dialogue = {
            "text": "Add practice routine/",
            "attachments": [
                {
                    "fallback": "!!!",
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

    def send_dialogue(dialogue, trigger_id)
        token = 'xoxp-406277854996-405804062576-406661989989-3f2429a732066e7d2f4d485d5d705c48'
        url = 'https://slack.com/api/dialog.open'
        data = dialogue.to_json
        headers = {
            :content_type => :json, 
            :authorization => token
            :trigger_id => trigger_id
        }
        response = RestClient.post(url, data, headers)
    end


end