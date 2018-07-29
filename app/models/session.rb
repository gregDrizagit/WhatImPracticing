class Session < ApplicationRecord 

    def self.add(data)
        Session.create(data)
    end
end