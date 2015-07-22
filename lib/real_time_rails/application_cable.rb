module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
    end
  end
  
  class Channel < ActionCable::Channel::Base
  end
end