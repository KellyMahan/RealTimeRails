module RealTimeRails
  module RealTimeCable
    class Connection < ActionCable::Connection::Base
    end
    
    class Channel < ActionCable::Channel::Base
      
      def subscribed
        stream_from 'real_time_rails'
      end
    end
  end
end