module RealTimeRails
  
  
  module RealTimeHelper
    
    def render_real_time(options = {})
      RealTimeRails::RtrHelper.new(options) do
        render options
      end.html
    end
  
  end
end

