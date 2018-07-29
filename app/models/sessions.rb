class Session < ApplicationRecord 

    def add(data)
        Session.create(data)
    end
end