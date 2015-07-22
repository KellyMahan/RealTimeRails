module RealTimeRails
  class RealTimeRailsController < ActionController::Base
  
    # Updates will pull data from this controller.
    # url in the form of '/render_real_time/id/#{md5_hash_id}'
    # The information is pulled from Rails.cache by the md5 hash id
    def update
      id = params[:id]
      websocket_options = Yaml.load(Rails.cache.read("real_time_#{id}"))
      render_options = Yaml.load(Rails.cache.read("real_time_#{id}_options"))
      model = websocket_options[:model]
    
      data = case model[:type]
      when :single
        eval(model[:name]).find(model[:id])
      when :array
        eval(model[:name]).where(id: model[:ids]).to_a
      when :relation
        eval(model[:name]).connection.execute(model[:sql])
      end
      locals = render_options[:locals].merge(model[:key] => data)
    
      render partial: render_options[:partial], locals: locals
    end
  end  
end
