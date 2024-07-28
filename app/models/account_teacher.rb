class AccountTeacher < ActiveRecord::Base
  belongs_to :account
  belongs_to :teacher
  audited

  validates :account_id, :presence => true
  validates :teacher_id, :presence => true, :uniqueness => { :scope => :account_id }
end
