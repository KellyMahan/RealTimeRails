module RealTimeRails
  
  # include RealTimeRails:AR in your model for access to realtime updates.
  module AR
    #after every save send notification to the realtimerails socket server.
    def self.included(klass)
      klass.send :after_save, :send_rtr_update
      klass.send :after_destroy, :send_rtr_destroy
    end
    
    private

    def send_rtr_update
      # TODO figure out why i have to make 2 connections to send 2 messages instead of just one connection.
      mySock = TCPSocket::new("#{RealTimeRails.config[:update_host]}", "#{RealTimeRails.config[:update_port]}")
      mySock.puts("{\"command\":\"update1\",\"model\":\"#{self.class.name}\",\"id\":\"#{self.id}\"}")
      mySock.close

      mySock = TCPSocket::new("#{RealTimeRails.config[:update_host]}", "#{RealTimeRails.config[:update_port]}")
      mySock.puts("{\"command\":\"updateall\",\"model\":\"#{self.class.name}\"}")
      mySock.close
    end
    
    
    def send_rtr_destroy
      # TODO figure out why i have to make 2 connections to send 2 messages instead of just one connection.
      mySock = TCPSocket::new("#{RealTimeRails.config[:update_host]}", "#{RealTimeRails.config[:update_port]}")
      mySock.puts("{\"command\":\"delete1\",\"model\":\"#{self.class.name}\",\"id\":\"#{self.id}\"}")
      mySock.close

      mySock = TCPSocket::new("#{RealTimeRails.config[:update_host]}", "#{RealTimeRails.config[:update_port]}")
      mySock.puts("{\"command\":\"updateall\",\"model\":\"#{self.class.name}\"}")
      mySock.close
    end
  end
  
end