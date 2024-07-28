import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Connected to NotificationsChannel");
  },

  disconnected() {
    console.log("Disconnected from NotificationsChannel");
  },

  received(data) {
    console.log("Received data: ", data);
    var audio = new Audio("/sound/notification_sound.mp3");
    audio.play();
    generateNotification(data.notification);
  }
});

function generateNotification(notification) {

  console.log("generetiong notifications.................................")

  notificationCount = $("#notification-count")
  notificationCount.text(parseInt($("#notification-count").text()) + 1)


  var newNotification = $('<li class="notification-item">' +
                            getNotificationIconWithCount(notification.status) +
                            '<div>' +
                              '<h4>New Notification</h4>' +
                              '<p>' + notification.message + '</p>' +
                              '<p>' + formattedTime(notification.created_at) + '</p>' +
                            // '<p>Just now</p>' +
                            '</div>' +
                          '</li>');

  // Append the new li element after the specific li element
  $('#top-notification-hr').after(newNotification);
}


function getNotificationIconWithCount(status) {
  if (status === 'completed') {
    return '<i class="bi bi-check-circle text-success"></i>'
  } else if (status === 'failed') {
    return '<i class="bi bi-x-circle text-danger"></i>'
  }
}

function formattedTime(time) {
    const now = new Date();
    const createdAt = new Date(time);
    const diffInSeconds = Math.floor((now - createdAt) / 1000);

    const intervals = {
      year: 31536000,
      month: 2592000,
      week: 604800,
      day: 86400,
      hour: 3600,
      minute: 60,
      second: 1
    };

    let timeAgoStr = '';

    for (const [key, value] of Object.entries(intervals)) {
      const interval = Math.floor(diffInSeconds / value);
      if (interval >= 1) {
        timeAgoStr = interval === 1 ? `${interval} ${key} ago` : `${interval} ${key}s ago`;
        break;
      }
    }

    if (!timeAgoStr) {
      timeAgoStr = 'just now';
    }

    return timeAgoStr;
}
