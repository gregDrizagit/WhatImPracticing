class Session < ApplicationRecord 

    def self.add(data)
        Session.create(data)
    end

    def self.get_last_session
        last = Session.all.last
    end

    def self.get_sessions_for_week
        result = Session.find(:all, :order => "id desc", :limit => 7);
    end

    def self.delete_session
    end

end