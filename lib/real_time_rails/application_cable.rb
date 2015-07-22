module ApplicationCable
  class Connection < ActionCable::Connection::Base
    
    def connect
    end
    
  end
  
  class Channel < ActionCable::Channel::Base
    def subscribed
      stream_from 'real_time_rails'
    end
  end
end