class Session < ApplicationRecord 

    has_many :exercises

    def self.add(data)
        @session = Session.create(data)
    end

    def find_and_delete()

    end
  
    def self.get_last_session
        last = Session.all.last
    end

    def self.get_today_session
        # should get session if if the last session's date matches today's date
    end

    def self.get_sessions_for_week
        result = Session.all[0..1]
    end

    def self.delete_session
    end

end