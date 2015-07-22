module RealTimeRails
  
  # include RealTimeRails:AR in your model for access to realtime updates.
  module ActiveRecord
    #after every save send notification to the realtimerails socket server.
    def self.included(klass)
      klass.send :after_save, :send_rtr_update
      klass.send :after_destroy, :send_rtr_destroy
    end
    
    def send_rtr_update
      RealTimeJob.perform_later(self, :update)
    end
    
    
    def send_rtr_destroy
      RealTimeJob.perform_later(self, :destroy)
    end
  end
  
end