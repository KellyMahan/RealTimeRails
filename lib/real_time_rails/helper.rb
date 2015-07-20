module RealTimeRails
  class Helper
    

    require 'digest/md5'
    
    attr_accessor   :options,
                    :id,
                    :html,
                    :websocket_options,
                    :javascript_options,
                    :render_options,
                    :wrap_options,
                    :remote_f_options
    
    def initialize(options = {})
      @options = options
      set_options
      register_partial
      html = ''
      html += wrap_render do
        yield
      end
      @html = html
    end
    
    def set_options
      @options[:real_time].each do |key,value|
        if value.is_a?(ActiveRecord::Base)
          model = {type: :single, key: key, name: value.class.name, id: value.id}
        end
        if value.is_a?(Array)
          if (class_name = value.map{|v| v.class.name}.uniq).length==1
            model = {type: :array, key: key, name: class_name.first, ids: value.map(&:id)}
          else
            raise "Can not do real time updates on arrays containing different models.\n#{value.map{|v| v.class.name}.uniq.to_yaml}"
          end
        end
        if value.is_a?(ActiveRecord::Relation)
          model = {type: :relation, key: key, name: value.ancestors.first.name, sql: value.to_sql.gsub('"','\"')}
        end
        break #make sure there is only one key value pair
      end
      @id = Digest::MD5.hexdigest(model.to_yaml)
      @websocket_options = {
        model: model,
        id: @id
      }
      @options[:locals].merge!(options[:real_time])
    end
    
    def register_partial
      Rails.cache.write("real_time_#{@id}", @websocket_options)
      Rails.cache.write("real_time_#{@id}_options", @options)
    end

    def wrap_render
      model = @websocket_options[:model]
      html = "<div id='#{@id}' class='real_time_wrapper' data-real-time-name='#{model[:name]} data-real-time-name='#{model[:type]} data-real-time-ids='#{model[:id]||model[:ids]||""}' >\n"
      html += yield
      #html += @websocket_options.to_yaml # TODO remove debugging data.
      html += "</div>\n"
      return html
    end
  end
end