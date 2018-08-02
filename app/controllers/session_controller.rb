class SessionController < ApplicationController

    def last 
        @last_session = Session.all.last
    end

end