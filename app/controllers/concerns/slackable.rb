module Slackable
    extend ActiveSupport::Concern

    
    def open_add_dialogue(trigger_id) 

        #eventually what should happen here is that we should only return todays session. Maybe. Or maybe it would be cool 
        #to put together routines
        options = Session.all.map {|session| {label:"#{session.created_at.strftime('%a %d %b %Y')} - #{session.notes}", value: session.id}}

        open_dialogue = {
            'trigger_id': trigger_id, 
            "dialog": {
                "callback_id": "add-exercise-dialogue",
                "title": "Add exercise",
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

        default_option = [{label: "#{session.created_at.strftime('%a %d %b %Y')} - #{session.notes}", value: session.id}]
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
                        "label": "What is your goal?",
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
        
        ##this needs to be major refactored because it's ugly and it probably won't work for more complex input 
        ##consider if you entered add and then delete. Add would go through first. Why didn't switch work
        ## it really should have been a case statement from the start.
        response_text = ""

        downcase_text = text.downcase

        if downcase_text.include? 'add'

            response_text = Slackable.add_trigger()

        elsif downcase_text.include? 'delete'

            response_text ="What do you want to delete"

        elsif downcase_text.include? "edit"

            response_text = "what do you want to edit"

        elsif downcase_text.include? 'show'

            response_text = show_all_sessions()

        elsif downcase_text.include? 'last'

            response_text = get_last_session()
            
        else
            response_text = "I don't know what that means. Say something that I know what it means."
        end

        response_text
        ##need command dictionary so people know how to work the damn things 
        
    end

    def show_all_sessions
        sessions = Session.get_sessions_for_week()

        session_objects = sessions.map do |session|
        {
            "title": session.created_at.strftime('%a %d %b %Y'),
            "text": session.notes,
            'callback_id': 'session_view',
            "actions": [
                {
                    "name": session.id,
                    "text": "View",
                    "type": "button",
                    "value": "View"
                }
            ]
        }
        end

        response = {
            "text": "Here are your most recent sessions",
            "attachments": session_objects
        }

    end

    def show_exercises_for_session(session)
        session.exercises.each do |exercise|
            {
                "title": "*#{exercise.name}*",
                "text": exercise.description,
                "pretext": "*Tempo:* #{exercise.tempo} - *Key:* #{exercise.key}",
                'callback_id': 'session_view',
                "mrkdwn_in": ["title", "pretext"],
                "actions": [
                    {
                        "name": session.id,
                        "text": "Edit",
                        "type": "button",
                        "value": "Edit"
                    }
                ]
            }
        end        
    end


    def get_last_session

        session = Session.get_last_session
        ## this needs to change becasues now sessions have exercises. 
        response = {
            "text": 'Here are the last things you practiced',
            "attachments":[
                {
                    "title": session.name,
                    "pretext": Date.new(session.created_at).strftime('%a %d %b %Y'),
                    "text": session.description,
                    "mrkdwn_in": ["text", "pretext"]
                }
            ]
        }

    end


    def parse_exercise_dialogue(resp)

        selected_session = Session.find(resp['select_session'].to_i)

        new_exercise = Exercise.create(description: resp["description"], 
                                       name: resp["name"],
                                       duration: resp['duration'],
                                       tempo: resp['tempo'], 
                                       key: resp['key'], 
                                       session_id: selected_session.id)
        selected_session
    end

    def current_session_response(session_id)

       session = Session.find(session_id.id)

       if session.exercises.length > 0
            exercises = session.exercises.map do |exercise|
                {
                    "title": "#{exercise.name}",
                    "pretext": "*Tempo:* #{exercise.tempo} - *Key:* #{exercise.key}",
                    "text": exercise.description,
                    "mrkdwn_in": ["text", "pretext"]
                   
                }
            end

            button = {
                "text": "Add another exercise?",
                "actions":[
                    {
                        "name": session.id,
                        "text": "Add exercise.",
                        "type": "button",
                        "value": "AddAnotherSession"
                    }
                ]
            }
                
            response = {
                "title": "*#{session.created_at.strftime('%a %d %b %Y')} - #{session.notes}*",
                "text": "Here are the exercises you practiced",
                "attachments": exercises
            }

            response[:attachments].push(button)
            response
        else

            response = {
                "text": "*No exercises for this session*.", 
                "mrkdown": true, 
                "attachments":[
                    "text": 'View recent sessions?',
                    'callback_id': "show_all_session", 
                    "actions":[
                        {
                            "name": "Show",
                            "text": "Show",
                            "type": "button",
                            "value": "Show"
                            
                        }
                    ]
                ]
            }

        end
    end


end