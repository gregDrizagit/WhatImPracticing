class Session < ApplicationRecord 

    def self.add(data)
        Session.create(data)
    end

    def self.get_last_session
        last = Session.all.last
    end
end