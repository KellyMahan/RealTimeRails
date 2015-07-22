class RealTimeRailsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "real_time_rails"
  end

  def unfollow
    stop_all_streams
  end
end