class RenderRealTimeController < ApplicationController
  
  # Updates will pull data from this controller.
  # url in the form of '/render_real_time/id/#{md5_hash_id}'
  # The information is pulled from Rails.cache by the md5 hash id
  
  def id
    websocket_options = YAML.load(Rails.cache.read("real_time_#{params[:id]}"))
    options = YAML.load(Rails.cache.read("real_time_#{params[:id]}_options"))
    locals = {}
    websocket_options[:models].each do |rtmodel|
      
      case rtmodel[:type]
        when :single
          locals[rtmodel[:key]] = eval("#{rtmodel[:name]}.find(rtmodel[:id])")
        when :array
          locals[rtmodel[:key]] = eval("#{rtmodel[:name]}.find(rtmodel[:ids])")
        when :relation
          rtmodel[:sql] = rtmodel[:sql].gsub('\"','"')
          locals[rtmodel[:key]] = eval("#{rtmodel[:name]}.find_by_sql(rtmodel[:sql])") #TODO This needs to recreate the arel object. Not just find_by_sql.
        else
          
      end
    end
    render :update do |page|
      page.replace_html params[:id], :partial => options[:partial], :locals => locals
    end
  end
  
end
