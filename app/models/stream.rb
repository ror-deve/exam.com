class Stream < ActiveRecord::Base
  has_and_belongs_to_many :accounts
  has_and_belongs_to_many :teachers 
  has_and_belongs_to_many :subjects, join_table: "streams_subjects", foreign_key: "steam_id", association_foreign_key: "subject_id"
  audited
  validates :name, :presence => true
end
