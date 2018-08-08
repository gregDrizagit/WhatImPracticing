class Session < ApplicationRecord 

    has_many :exercises

    def self.add(data)
        @session = Session.create(data)
    end

    def self.get_last_session
        last = Session.all.last
    end

    def self.get_sessions_for_week
        result = Session.all[0..5]
    end


end