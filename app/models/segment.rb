class Segment < ActiveRecord::Base
  has_and_belongs_to_many :papers
  has_and_belongs_to_many :exams
  belongs_to :account

  validates :name, :presence => true
  validates :account_id, :presence => true
end
