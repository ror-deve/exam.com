class Subject < ActiveRecord::Base
  has_and_belongs_to_many :streams, join_table: "streams_subjects", foreign_key: "subject_id", association_foreign_key: "steam_id"
  has_and_belongs_to_many :teachers
  has_many :topics
  audited

  # pagination
  self.per_page = 9
  
  validates :name, :presence => true

  scope :search_by_name, ->(query) {
    where("name ILIKE :search", search: "%#{query}%")
  }
end
