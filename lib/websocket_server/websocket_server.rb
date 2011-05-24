# to start the server just run "ruby websocket_server.rb"

require 'em-websocket'
require 'json'
require 'yaml'

class RTChannel < EM::Channel
  
  attr_accessor   :id,
                  :models,
                  :subscribers
                  
  def self.create(id, models)
    sid = self.new
    sid.id=id
    sid.models=models
    sid.subscribers=[]
    return sid
  end
  
  def join(subscriber)
    @subscribers << subscriber
  end
  
  def leave(subscriber, subscription_id)
    @subscribers.delete(subscriber)
    self.unsubscribe(subscription_id)
  end
  
end

EventMachine.run {


  #$global_channel = EM::Channel.new
  $channel_list = []


  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen do
      puts "opened conneciton"
    end
    ws.onmessage do |msg|
      data = JSON.parse(msg)
      puts "new message:\n#{msg}"
      @subscriber = data["subscriber"]
      case data["command"]
        when "listen"
          unless @channel = $channel_list.find{|channel| channel.id == data["id"]}
            @channel = RTChannel.create(data["id"], data["models"])
            $channel_list << @channel
          end
          @sid = @channel.subscribe{|msg| ws.send msg}
          @channel.join(@subscriber)
        else
          puts "unknown command: #{msg}"
      end
    end
    ws.onclose { 
      # $channel_list.each do |channel|
      #   if channel.subscribers.include?(@subscriber)
          @channel.leave(@subscriber, @sid)
      #   end
      # end
    }
  end

  module MessageServer

      def post_init
         send_data "connected to update server\n"
         puts "new connection\n"
      end

      def unbind
        #puts "-- someone disconnected from the server!"
      end
      
      def find_channels_by_id(model_name, id =nil)
        channel_list = []
        $channel_list.each{|channel| 
          if models = channel.models.select{|m| m["name"]==model_name}
            models.each do |m|
              if (m["type"] == "single") && (m["id"].to_s == id.to_s) && (m["name"] == model_name)
                channel_list << channel
              end
              if (m["type"] == "array") && (m["ids"].map(&:to_s).include?(id.to_s)) && (m["name"] == model_name)
                channel_list << channel
              end
            end
            
          end
        }
        return channel_list
      end
      
      def find_all_channels(model_name)
        $channel_list.select{|channel| 
          channel.models.map{|m| m["name"]}.include?(model_name) &&
          channel.models.map{|m| m["type"]}.include?("relation")
        }
      end
      

      def receive_data data
          close_connection if data =~ /quit/i
          if data =~ /info/i
            send_data "channels:\n#{$channel_list.to_yaml}\n"
          else
            begin
              command = JSON.parse(data)
              puts command
              case command["command"]
                when "update1"
                  channels = find_channels_by_id(command["model"], command["id"])
                  channels.each{|c| c.push "update"}
                when "updateall"
                  channels=find_all_channels(command["model"])
                  channels.each{|c| c.push "update"}
                when "info"
                  send_data "channels:\n#{$channel_list.to_yaml}\n"
                else
                  puts "unknown command: #{command["command"]}\n"
                  send_data "unknown command: #{command["command"]}\n"
              end
            rescue JSON::ParserError
              puts "unknown command: \n#{data}"
              send_data "unknown command:\n#{data}"
            end
          end
      end
  end

  EventMachine::start_server "0.0.0.0", 2000, MessageServer
  puts 'Running message server on 2000'

  # is ping needed to keep a connection open?
  # EventMachine::PeriodicTimer.new(5) do 
  #   $channel.push "ping"
  # end

  puts "loaded"
}