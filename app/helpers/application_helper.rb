module ApplicationHelper
  def flash_class(level)
    bootstrap_alert_class = {
      "success" => "alert-success",
      "error" => "alert-danger",
      "notice" => "alert-info",
      "alert" => "alert-danger",
      "warn" => "alert-warning"
    }
    bootstrap_alert_class[level]
  end

  def is_current? account_id
    current_account and (account_id == current_account.id)
  end
  
  def seconds_to_time secs
    Time.at(secs.to_i).gmtime.strftime('%H:%M:%S')
  end

  def nice_time time
    time.strftime("%b %d, %Y at %I:%M%p") unless time.nil?
  end
end
