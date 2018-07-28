Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  post '/', to: "slack#event_receiver"
  post '/add', to "slack#open_add_dialogue"

end
