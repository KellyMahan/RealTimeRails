# autoload :ActionCable, 'actioncable'

require 'real_time_rails/version.rb'
require 'real_time_rails/engine.rb'
require 'real_time_rails/helper.rb'
require 'real_time_rails/active_record.rb'
require 'real_time_rails/application_cable.rb'
#require 'real_time_rails/real_time_rails_channel.rb'
require 'real_time_rails/real_time_helper.rb'
# require 'real_time_rails/real_time_job.rb'
require 'real_time_rails/render_real_time_controller.rb'
# autoload :ActionCable, 'real_time_rails/action_cable/server/base.rb'
# autoload :ActionCable, 'real_time_rails/action_cable/server/configuration.rb'

if defined?(ActionView::Base)
  ActionView::Base.send :include, RealTimeRails::RealTimeHelper
end



