function pushNotify(status, title, text) {
  new Notify({
    status: status,
    title: title,
    text: text,
    effect: 'fade',
    speed: 600,
    customClass: '',
    customIcon: '',
    showIcon: true,
    showCloseButton: true,
    autoclose: true,
    autotimeout: 10000,
    notificationsGap: null,
    notificationsPadding: null,
    type: 'outline',
    position: 'right top',
    customWrapper: '',
  });
}

export { pushNotify };