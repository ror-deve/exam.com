class Batch < ActiveRecord::Base
  has_many :exams
  has_many :subscriptions
  has_many :students, :through => :subscriptions
  audited
  belongs_to :account

  # pagination
  self.per_page = 6

  validates :name, :presence => true
  validates :account_id, :presence => true
end
