module RealTimeRails
  
  # include RealTimeRails:AR in your model for access to realtime updates.
  module ActiveRecord
    #after every save send notification to the realtimerails socket server.
    
    def self.included(klass)
      klass.send :after_save, :send_rtr_update
      klass.send :after_destroy, :send_rtr_destroy
    end
  
    def send_rtr_update
      #TODO Write new broadcast messages
      # ActionCable.server.broadcast "real_time_rails",
      #   action: "update_list",
      #   classname: "#{self.class.name}"
      ActionCable.server.broadcast "real_time_rails",
        action: "update",
        classname: "#{self.class.name}",
        objectid: self.id
    end
  
  
    def send_rtr_destroy
      #TODO Write new broadcast messages
      # ActionCable.server.broadcast "real_time_rails",
      #   action: "destroy_list",
      #   classname: "#{self.class.name}"
      ActionCable.server.broadcast "real_time_rails",
        action: "destroy",
        classname: "#{self.class.name}",
        objectid: self.id
    end
  end
  
end