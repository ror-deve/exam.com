class Answer < ActiveRecord::Base
  belongs_to :account
  belongs_to :student
  belongs_to :paper_session
  belongs_to :question
  audited

  validates :account_id,        :presence => true
  validates :student_id,        :presence => true
  validates :paper_session_id,  :presence => true
  validates :question_id,       :presence => true
  validates :answer,            :presence => true
end
