class Question < ActiveRecord::Base
  has_and_belongs_to_many :papers
  belongs_to :account
  belongs_to :topic

  audited
  # pagination
  self.per_page = 8
  
  validates :account_id, :presence => true
  validates :title, :presence => true
  validates :answer, :presence => true
  validates :topic_id, :presence => true
  validate do
    selected_options = [option1, option2, option3, option4, option5].select{|i| i.present? }
    if selected_options.length < 3
      self.errors.add(:title, "atleast 3 options should be given and one correct option.")
    end
  end

  # serialize :answer
end
