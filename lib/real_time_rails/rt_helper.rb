module RealTimeRails
  class RtrHelper

    require 'digest/md5'

    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::PrototypeHelper
    include ActionView::Helpers::JavaScriptHelper

    def protect_against_forgery?
      false
    end

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
      html = load_javascript
      #html += manual_buttons #TODO remove test helper for ajax update calls. 
      html += wrap_render do
        yield
      end
      @html = html
    end

    def set_options
      model_list = []
      @options[:locals].each do |key,value|
        if value.is_a?(ActiveRecord::Base)
          model_list << {type: :single, key: key, name: value.class.name, id: value.id}
        end
        if value.is_a?(Array)
          if (class_name = value.map{|v| v.class.name}.uniq).length==1
            model_list << {type: :array, key: key, name: class_name.first, ids: value.map(&:id)}
          else
            raise "Can not do real time updates on arrays containing different models.\n#{value.map{|v| v.class.name}.uniq.to_yaml}"
          end
        end
        if value.is_a?(ActiveRecord::Relation)
          model_list << {type: :relation, key: key, name: value.ancestors.first.name, sql: value.to_sql.gsub('"','\"')}
        end
      end
      @websocket_options = {
        models: model_list,
        command: 'listen'
      }
      @id = Digest::MD5.hexdigest(@websocket_options.to_yaml)
      @websocket_options = {
        models: model_list,
        command: 'listen',
        id: @id
      }
    end

    # TODO remove test helper method for ajax update calls.
    def manual_buttons
      "<a href='#' onclick='real_time_update_#{@id}();'>Manual Update</a>\n"
    end

    def load_javascript
      @remote_f_options = {
        url: "/render_real_time/id/#{@id}"
      }

      html = "<script>\n"
      html += js_after_update
      html += js_remote_function
      html += js_start_websocket
      html += "</script>\n"
      return html
    end


    # Adds the wrapper for creating the connection to the websocket server as well as registering for the correct channel on the server.
    def js_start_websocket
      "
      var Socket = \"MozWebSocket\" in window ? MozWebSocket : WebSocket;
      ws_#{@id} = new Socket('ws://#{RealTimeRails.config[:websocket_host]}:#{RealTimeRails.config[:websocket_port]}');
      ws_#{@id}.onmessage = function(evt) { 
        if(evt.data=='update'){real_time_update_#{@id}()}; 
        if(evt.data=='delete'){real_time_delete_#{@id}()};  
      };
      ws_#{@id}.onclose = function() {  };
      ws_#{@id}.onopen = function() {
        ws_#{@id}.send('#{@websocket_options.to_json}');
      };
      "
    end

    def js_after_update
      if @options[:after_update]
        @remote_f_options[:complete] = "after_real_time_update_#{@id}();"
        return "function after_real_time_update_#{@id}(){#{@options[:after_update]}}"
      else
        return ""
      end
    end

    # Creates the js method wrapper for ajax calls.
    def js_remote_function
      "function real_time_update_#{@id}(){
        #{remote_function(remote_f_options)}
      }
      function real_time_delete_#{@id}(){
        $('##{@id}').remove;
      }"
    end

    def wrap_render
      html = "<div id='#{@id}' class='real_time_wrapper'>\n"
      html += yield
      #html += @websocket_options.to_yaml # TODO remove debugging data.
      html += "</div>\n"
      return html
    end

    
    # Writes data to cache for later use in the render_real_time controller.
    def register_partial
      Rails.cache.write("real_time_#{@id}", @websocket_options.to_yaml)
      Rails.cache.write("real_time_#{@id}_options", @options.to_yaml)
    end
  end
end