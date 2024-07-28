require 'csv'
require 'bcrypt'
class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

# associations
  has_many :subscriptions
  has_many :batches, :through => :subscriptions
  has_many :exams, :through => :batches
  has_many :accounts, :through => :subscriptions
  has_many :answers
  has_many :paper_sessions
  has_many :exam_sessions
  has_one_attached :avatar
  has_many :notifications
  
  audited
  has_associated_audits

  # pagination
  self.per_page = 6

  # validations
  validates :name,  :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :phone, :presence => true, :numericality => true, :uniqueness => true
    
  # scopes
  scope :search_by_name_or_email, ->(query) {
    where("name ILIKE :search OR email ILIKE :search", search: "%#{query}%")
  }

  # class methods
  def self.import_from_csv(data = {})
    puts "CSV parsing started"
    student_data = []
    existing_student = []
    CSV.parse(data[:file_path], headers: true) do |row|
      student_attributes = {
        name: row['Name'],
        email: row['Email'],
        phone: row['Phone'],
        address: row['Address'],
        encrypted_password: BCrypt::Password.create(row['Password']) # Hashing the password
      }

      student_data << student_attributes
    end
    emails = student_data.map { |s| s[:email] }
    existing_student = Student.where(email: emails).pluck(:email)
    student_data.reject! { |s| existing_student.include?(s[:email]) }

    if student_data.any?
      students = Student.insert_all(student_data)
      if students.any?
        batch = Batch.find(data[:batch_id])
        subscriptions = students.map { |student| { student_id: student['id'], batch_id: batch.id, account_id: batch.account_id } }
        Subscription.insert_all!(subscriptions)
      else
        puts "No students were inserted."
      end
    end

    puts "--------------------------------------------------------------------------------------"
    puts "Imported #{student_data.size}"
    puts "duplicate #{existing_student.count}"
    puts "--------------------------------------------------------------------------------------"
    return { total_imported: student_data.size, duplicate_count: existing_student.count }
  end

  def self.export_to_csv(batch_id)
    batch = Batch.find(batch_id)
    file_path = Rails.root.join('tmp', "students_#{Time.now.to_i}.csv")
    attributes_to_export = %w[Name Email Phone Address Password]

    CSV.open(file_path, 'wb') do |csv|
      csv << attributes_to_export
      batch.students.each do |student|
        csv << student.attributes.values_at(*attributes_to_export.map(&:downcase))
      end
    end

    file_path.to_s
  end

  # object methods

  def notifications_count
    self.notifications.count rescue 0
  end

  def unread_notifications_count
    self.notifications.unread_notifications.count
  end
end
