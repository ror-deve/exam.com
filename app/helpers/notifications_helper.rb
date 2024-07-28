module NotificationsHelper
  def notification_item(notification)
    icon_class = icon_class_for(notification)
    time_ago = format_time_ago(notification.created_at)
    
    content_tag(:li, class: 'notification-item') do
      concat(content_tag(:i, '', class: icon_class))
      concat(
        content_tag(:div) do
          concat(content_tag(:p, notification.message))
          concat(content_tag(:p, time_ago, class: 'text-muted'))
        end
      )
    end +
    content_tag(:li) do
      content_tag(:hr, '', class: 'dropdown-divider')
    end
  end

  def icon_class_for(notification)
    case notification.status
    when 'completed'
      'bi bi-check-circle text-success'
    when 'failed'
      'bi bi-x-circle text-danger'
    else
      'bi bi-exclamation-circle text-warning'
    end
  end

  def format_time_ago(time)
    if time > 1.day.ago
      time_ago_in_words(time) + ' ago'
    else
      time.strftime("%b %d, %Y %H:%M")
    end
  end
end
