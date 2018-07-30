namespace :scheduler do
    task :daily_reminder do 
        ApplicationController.daily_reminder()
    end
end
