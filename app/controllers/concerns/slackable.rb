module Slackable
    extend ActiveSupport::Concern

    def open_add_dialogue(trigger_id) 
        open_dialogue = {
            'trigger_id': trigger_id, 
            "dialog": {
                "callback_id": "add-session-dialogue",
                "title": "What did you practice today?",
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
                    }
                    {
                        "type": "text",
                        "label": "Tempo",
                        "name": "tempo"
                    }
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

end