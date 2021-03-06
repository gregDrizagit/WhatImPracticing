class SlackController < ApplicationController

    include Slackable

    def event_receiver
        puts params
        if params['event'] # did we get an event message or a payload

            if params['event']['type'] == "app_mention" # if we got an app mention 

                response_text = parse_text(params['event']['text']) #see what the message was
                SlackController.send_response(response_text) #send the response

            end

        elsif params['payload']

                json = JSON.parse(params["payload"])

                if json['type'] == "interactive_message"

                    interactive_message(json)
                
                elsif json['type'] == "dialog_submission"

                    dialog_submission(json)

                end
        end
        
    end


    def interactive_message(json)

        case json['actions'][0]['value']
            
        when "Add"
            add_dialogue = open_add_dialogue(json['trigger_id'])
            SlackController.send_dialogue(add_dialogue)
        when "New"
            new_session_dialogue = open_new_session_dialogue(json["trigger_id"])
            SlackController.send_dialogue(new_session_dialogue)
        when "AddToSession"
            preselected_session_dialogue = open_preselected_session_dialogue(json['trigger_id'], Session.all.last)
            SlackController.send_dialogue(preselected_session_dialogue)
        when "View"
            session = Session.find(json['actions'][0]['name'].to_i)
            response = current_session_response(session)
            SlackController.send_response(response)
        when "Show"
            response = show_all_sessions()
            SlackController.send_response(response)
        when "AddAnotherSession"
            session = Session.find(json['actions'][0]['name'].to_i)
            response = open_preselected_session_dialogue(json['trigger_id'], session)
            SlackController.send_dialogue(response)
        else

        end
   
    end

    def dialog_submission(json)

        if json['callback_id'] == "add-exercise-dialogue"
                        
            session = parse_exercise_dialogue(json['submission'])

            SlackController.send_response(current_session_response(session))

        elsif json['callback_id'] == "new-session-dialogue"

            Session.add(json['submission'])

            SlackController.send_response(add_exercise_to_session_trigger())
        end

    end
   
    def self.send_response(res)
        url = 'https://hooks.slack.com/services/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'
        data = res.to_json
        response = RestClient.post(url, data, {:content_type => :json, :accept => :json})
    end

    def self.send_message_followup(message, url)

        token = 'Bearer xoxb-406277854996-406582689938-SNKLIUU3erryz00MrZDGdOl3'
        data = message.to_json
        headers = {
            :content_type => :json, 
            :Authorization => token,
        }
        response = RestClient.post(url, data, headers)
        puts response

    end

    def self.send_dialogue(dialogue)
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

    def self.daily_reminder
    
        send_response(Slackable.add_trigger())
        
    end

end