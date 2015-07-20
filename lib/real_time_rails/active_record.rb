module RealTimeRails
  
  # include RealTimeRails:AR in your model for access to realtime updates.
  module ActiveRecord
    #after every save send notification to the realtimerails socket server.
    def self.included(klass)
      klass.send :after_save, :send_rtr_update
      klass.send :after_destroy, :send_rtr_destroy
    end
    
    private

    def send_rtr_update
      #TODO Write new broadcast messages
      RealTimeCable.server.broadcast "real_time_rails_#{self.class.name}",
        action: "update_list",
        class: "#{self.class.name}"
      RealTimeCable.server.broadcast "real_time_rails_#{self.class.name}_#{self.id}",
        action: "update",
        class: "#{self.class.name}",
        id: self.id
    end
    
    
    def send_rtr_destroy
      #TODO Write new broadcast messages
      RealTimeCable.server.broadcast "real_time_rails_#{self.class.name}",
        action: "destroy_list",
        class: "#{self.class.name}"
      RealTimeCable.server.broadcast "real_time_rails_#{self.class.name}_#{self.id}",
        action: "destroy",
        class: "#{self.class.name}",
        id: self.id
    end
  end
  
end