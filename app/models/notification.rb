class Notification < ApplicationRecord
  belongs_to :student, optional: true
  belongs_to :teacher, optional: true

  # scopes
  scope :unread_notifications, ->() { where(read: false)}
end
