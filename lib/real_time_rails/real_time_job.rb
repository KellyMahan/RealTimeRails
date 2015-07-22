class RealTimeJob < ApplicationJob
  def perform(object, action)
    case action
    when :update
      send_rtr_update(object)
    when :destroy
      send_rtr_destroy(object)
    else
      raise "Not a valid RealTimeRails action"
    end
  end
  
  private
  
  def send_rtr_update(object)
    #TODO Write new broadcast messages
    RealTimeCable.server.broadcast "real_time_rails_#{object.class.name}",
      action: "update_list",
      class: "#{object.class.name}"
    RealTimeCable.server.broadcast "real_time_rails_#{object.class.name}_#{object.id}",
      action: "update",
      class: "#{object.class.name}",
      id: object.id
  end
  
  
  def send_rtr_destroy(object)
    #TODO Write new broadcast messages
    RealTimeCable.server.broadcast "real_time_rails_#{object.class.name}",
      action: "destroy_list",
      class: "#{object.class.name}"
    RealTimeCable.server.broadcast "real_time_rails_#{object.class.name}_#{object.id}",
      action: "destroy",
      class: "#{object.class.name}",
      id: object.id
  end
end