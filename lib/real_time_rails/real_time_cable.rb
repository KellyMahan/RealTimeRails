module RealTimeRails
  module RealTimeCable
    class RealTimeConnection < ActionCable::Connection::Base
      
      def connect
      end
      
    end
    
    class RealTimeChannel < ActionCable::Channel::Base
      def subscribed
        stream_from 'real_time_rails'
      end
    end
  end
end