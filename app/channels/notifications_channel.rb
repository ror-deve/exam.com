class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    puts "subscribed-------------------------------------------------"
    stream_from "notifications_channel"
    # stream_from "notification_channel_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
