class Subscription < ActiveRecord::Base
  belongs_to :account
  belongs_to :student
  belongs_to :batch
  audited

  validates :account_id, :presence => true
  validates :student_id, :presence => true
  validates :batch_id, :presence => true, :uniqueness => { :scope => [:account_id, :student_id] }

  accepts_nested_attributes_for :student
  validates_associated :student
end
