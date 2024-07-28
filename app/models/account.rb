class Account < ActiveRecord::Base
  # associations
  has_and_belongs_to_many :streams
  has_many :batches
  has_many :subscriptions
  has_many :students, :through => :subscriptions
  has_many :account_teachers
  has_many :teachers, :through => :account_teachers
  has_many :exams
  has_many :exam_sessions
  has_many :papers
  has_many :paper_sessions
  has_many :answers
  has_many :questions
  has_many :segments
  belongs_to :owner, :class_name => "Teacher"

  audited
  has_associated_audits
  # validations
  validates :owner_id, :presence => true
  validates :name, :presence => true
  validates :email, :presence => true
  validates :phone, :presence => true, :numericality => true
  validates :address, :presence => true

  # pagination
  self.per_page = 3
end
