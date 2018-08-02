class Session < ApplicationRecord 

    has_many :exercises

    def self.add(data)
        session = Session.create(data)
        session 
    end

    def self.get_last_session
        last = Session.all.last
    end

    def self.get_today_session
        # should get session if if the last session's date matches today's date
    end

    def self.get_sessions_for_week
        result = Session.find(:all, :order => "id desc", :limit => 7);
    end

    def self.delete_session
    end

end