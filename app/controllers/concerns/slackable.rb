module Slackable
    extend ActiveSupport::Concern

    
    def open_add_dialogue(trigger_id) 

        #eventually what should happen here is that we should only return todays session. Maybe. Or maybe it would be cool 
        #to put together routines
        options = Session.all.map {|session| {label:"#{session.created_at} - #{session.notes}", value: session.id}}

        open_dialogue = {
            'trigger_id': trigger_id, 
            "dialog": {
                "callback_id": "add-exercise-dialogue",
                "title": "Practice?",
                "submit_label": "Submit",
                "notify_on_cancel": true,
                "elements": [
                    {
                        "label": "Select session",
                        "type": "select",
                        "name": "select_session",
                        "options": options
                    },
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

    def open_preselected_session_dialogue(trigger_id, session)

        default_option = {label: "#{session.created_at} - #{session.notes}", value: session.id}
        open_dialogue = {
            'trigger_id': trigger_id, 
            "dialog": {
                "callback_id": "add-exercise-dialogue",
                "title": "Practice?",
                "submit_label": "Submit",
                "notify_on_cancel": true,
                "elements": [
                    {
                        "label": "Select session",
                        "type": "select",
                        "name": "select_session",
                        "options": default_option,
                        "value": session.id
                    },
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

    def open_new_session_dialogue(trigger_id)
        open_dialogue = {
            'trigger_id': trigger_id, 
            "dialog": {
                "callback_id": "new-session-dialogue",
                "title": "What are you working on?",
                "submit_label": "Submit",
                "notify_on_cancel": true,
                "elements": [
                    {
                        "type": "text",
                        "label": "Exercise Name",
                        "name": "notes"
                    }
                ]
            }
        }
    end

  
    def add_exercise_to_session_trigger()
        dialogue = {
            "text": "Add exercise to session!",
            "attachments": [
                {
                    "fallback": "!!!",
                    "callback_id": "add_session",
                    "color": "#3AA3E3",
                    "attachment_type": "default",
                    "actions": [
                        {
                            "name": "Add",
                            "text": "Add exercise to session.",
                            "type": "button",
                            "value": "AddToSession"
                        }
                    ]
                }
            ]
        }
    end

    def self.add_trigger
        dialogue = {
            "text": "Add practice routine!",
            "attachments": [
                {
                    "fallback": "!!!",
                    "callback_id": "add_session",
                    "color": "#3AA3E3",
                    "attachment_type": "default",
                    "actions": [
                        {
                            "name": "New",
                            "text": "New practice session.",
                            "type": "button",
                            "value": "New"
                        },
                        {
                            "name": "Add",
                            "text": "Add exercise to session.",
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

            response_text = Slackable.add_trigger()

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

    def new_session 
        # Session.create( )
    end

    def get_last_session

        session = Session.get_last_session

        response = {
            "text": 'Here are the last things you practiced',
            "attachments":[
                {
                    "title": session.name,
                    "pretext": session.created_at ,
                    "text": session.description,
                    "mrkdwn_in": ["text", "pretext"]
                }
            ]
        }

    end

    def get_sessions_for_week

        # sessions = Session.get_sessions_for_week 

        # response = {
        #     "text": 'Here are the last things you practiced',
        #     "attachments":[
        #         {
        #             "title": session.name,
        #             "pretext": session.created_at ,
        #             "text": session.description,
        #             "mrkdwn_in": ["text", "pretext"]
        #         }
        #     ]
        # }

        # if sessions.length < 7
        #     response['text'] = "There isn't a weeks worth of sessions. "
        # else
        #     session_objects = sessions.map do |session|
        #         session_object = {
        #             "title": session.name,
        #             'pretext': session.created_at,
        #             'text': session.description,
        #             'markdwn_in': ['text', 'pretext']
        #         }
        #     end

        #     response["attachments"] = session_objects

        #     send_response(response)

        # end
    end

    
    def parse_session_dialogue(resp)

    end

    def parse_exercise_dialogue(resp)

        selected_session = Session.find(resp['select_session'])

        new_exercise = Exercise.create(description: resp["description"], 
                                       name: resp["name"],
                                       duration: resp['duration'],
                                       tempo: resp['tempo'], 
                                       key: resp['key'], 
                                       session_id: selected_session.id)

        selected_session
    end

    def current_session_response(session)

       exercises = session.exercises.map do |exercise|
            {
                "title": exercise.name,
                "pretext": "#{exercise.tempo} #{exercise.key}",
                "text": exercise.description,
                "mrkdwn_in": ["text", "pretext"]
            }
        end

        response = {
            "text": "#{session.created_at} - #{session.notes}",
            "attachments": exercises
        }
    end


end