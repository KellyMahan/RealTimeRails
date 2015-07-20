module RealTimeRails
  module RealTimeHelper
    # used just like render :partial, {options}
    def render_real_time(options = {})
      RealTimeRails::Helper.new(options) do
        render options
      end.html
    end
  
  end
end

