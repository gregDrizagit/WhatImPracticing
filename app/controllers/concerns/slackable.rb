module Slackable
    extend ActiveSupport::Concern

    def open_add_dialogue(trigger_id) 
        open_dialogue = {
            'trigger_id': trigger_id, 
            "dialog": {
                "callback_id": "add-session-dialogue",
                "title": "Practice?",
                "submit_label": "Submit",
                "notify_on_cancel": true,
                "elements": [
                    {
                        "type": "text",
                        "label": "Exercise Name",
                        "name": "name"
                    },
                    {
                        "type": "text",
                        "label": "Description",
                        "name": "description"
                    },
                    {
                        "type": "text",
                        "label": "Tempo",
                        "name": "tempo"
                    },
                    {
                        "type": "text",
                        "label": "Key Signature",
                        "name": "key"
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

    def parse_text(text)
        
        response_text = ""

        downcase_text = text.downcase

        if downcase_text.include? 'add'
            response_text = add_trigger()
        elsif downcase_text.include? 'delete'
            response_text ="What do you want to delete"
        elsif downcase_text.include? "edit"
            response_text = "what do you want to edit"
        elsif downcase_text.include? 'last'
            response_text = get_last_session()
            
        else
            response_text = "I don't know what that means. Say something that I know what it means."
        end

        response_text
        
    end

    def get_last_session

        session = Session.get_last_session
        
        response = {
            "text": 'Here are the last things you practiced',
            "attachments":[
                {
                    "title": session.name,
                    "pretext": DateTime.new(session.created_at),
                    "text": session.description,
                    "mrkdwn_in": ["text", "pretext"]
                }
            ]
        }

    end

  

    def parse_dialogue(resp)
        submission = resp['submission']
       
        Session.add(submission)
    end


end