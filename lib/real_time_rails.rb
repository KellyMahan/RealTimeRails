require 'real_time_rails/version.rb'
require 'real_time_rails/real_time_helper.rb'
require 'real_time_rails/render_real_time_controller.rb'
require 'real_time_rails/ar.rb'
require 'real_time_rails/rt_helper.rb'

if defined?(ActionView::Base)
  ActionView::Base.send :include, RealTimeRails::RealTimeHelper
end

module RealTimeRails
  class Engine < Rails::Engine
  end
end


