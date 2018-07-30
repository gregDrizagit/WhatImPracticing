namespace :scheduler do
    # require './app/controllers/slack_controller.rb'


    task :daily_reminder => :environment do 
        SlackController.daily_reminder()
    end
end
