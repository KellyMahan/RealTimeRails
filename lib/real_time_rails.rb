require 'real_time_rails/version.rb'
require 'real_time_rails/engine.rb'
require 'real_time_rails/helper.rb'
require 'real_time_rails/active_record.rb'
require 'real_time_rails/application_cable.rb'
require 'real_time_rails/real_time_helper.rb'
require 'real_time_rails/render_real_time_controller.rb'

if defined?(ActionView::Base)
  ActionView::Base.send :include, RealTimeRails::RealTimeHelper
end

module RealTimeRails
  class Engine < Rails::Engine
  end
end


