class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # associations
  has_and_belongs_to_many :streams
  has_and_belongs_to_many :subjects
  has_many :account_teachers
  has_many :accounts, :through => :account_teachers
  has_many :admin_accounts, ->{ where('account_teachers.admin = ?', true) }, :through => :account_teachers, :source => :account
  has_many :batches, :through => :accounts
  has_many :notifications
  has_one_attached :avatar
  audited
  has_associated_audits

  # validations
  validates :name, :presence => true
  validates :email, :presence => true
  validates :phone, :presence => true, :numericality => true, :uniqueness => true

  def is_admin? account_id
    AccountTeacher.where(:teacher_id => self.id, :account_id => account_id, :admin => true).exists?
  end

  # object methods
  
  def notifications_count
    self.notifications.count rescue 0
  end

  def unread_notifications_count
    self.notifications.unread_notifications.count
  end
end 
