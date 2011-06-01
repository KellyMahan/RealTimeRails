module RealTimeRails
  
  # include RealTimeRails:AR in your model for access to realtime updates.
  module AR
    #after every save send notification to the realtimerails socket server.
    def self.included(klass)
      klass.send :after_save, :send_rtr_update
    end
    
    private

    def send_rtr_update
      # TODO figure out why i have to make 2 connections to send 2 messages instead of just one connection.
      
      mySock = TCPSocket::new('127.0.0.1', 2000)
      mySock.puts("{\"command\":\"update1\",\"model\":\"#{self.class.name}\",\"id\":\"#{self.id}\"}")
      mySock.close

      mySock = TCPSocket::new('127.0.0.1', 2000)
      mySock.puts("{\"command\":\"updateall\",\"model\":\"#{self.class.name}\"}")
      mySock.close
    end
  end
  
end