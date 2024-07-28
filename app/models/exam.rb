class Exam < ActiveRecord::Base
  has_and_belongs_to_many :batches
  has_and_belongs_to_many :segments
  has_many :exam_sessions
  has_many :papers
  belongs_to :account
  belongs_to :batch
  audited

  validates :name, :presence => true
  validates :account_id, :presence => true
  validates :batch_id, :presence => true
  validates :duration, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true

  self.per_page = 8

  scope :live, ->{ where('start_time <= ? and end_time > ?', Time.zone.now, Time.zone.now) }

  def live?
    start_time <= Time.zone.now and end_time > Time.zone.now
  end

  def expired?
    end_time <= Time.zone.now
  end

  def upcoming?
    start_time > Time.zone.now
  end

  scope :search_by_name, ->(query) {
    where("name ILIKE :search", search: "%#{query}%")
  }
end
