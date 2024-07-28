class Topic < ActiveRecord::Base
  has_and_belongs_to_many :papers
  has_many :questions
  belongs_to :subject
  audited

  validates :name, :presence => true
  validates :subject_id, :presence => true
  
  # pagination
  self.per_page = 6

  def to_s
    name
  end
  
  scope :search_by_name, ->(query) {
    where("name ILIKE :search", search: "%#{query}%")
  }
end
