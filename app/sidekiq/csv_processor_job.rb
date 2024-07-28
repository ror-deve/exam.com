require 'csv'
require 'sidekiq-unique-jobs'
require 'redis'

class CsvProcessorJob
  include Sidekiq::Job

  sidekiq_options unique: :until_executed, retry: 0

  def perform(action, params = {})
    @file_path = params['file_path']
    @batch_id = params['batch_id']
    @teacher_id = params['teacher_id']
    @student_id = params['student_id']
    @import_result = nil

    begin
      case action
      when 'import'
        raise "Error: File does not exist or path is invalid: #{@file_path}" unless @file_path
        @import_result = Student.import_from_csv(file_path: @file_path, batch_id: @batch_id)
        status = "completed"
        message = "Import successfully completed. Imported: #{@import_result[:total_imported]}, Duplicate: #{@import_result[:duplicate_count]}"
      when 'export'
        status = "completed"
        message = "Export successfully completed."
      else
        raise "Error: Unsupported action '#{action}'"
      end
    rescue StandardError => exception
      status = "failed"
      case exception.cause
      when PG::NotNullViolation
        message = "Import failed. Error: 'CSV header is incorrect'"
      else
        message = "Import failed. Something went wrong."
      end
      raise exception
    ensure
      create_notification_once(status, message)
    end
  end

  private

  def create_notification_once(status, message)
    redis = Redis.new
    notification_key = "notification_created_for_#{jid}"

    unless redis.get(notification_key)
      notification_params = {
        job_id: jid,
        status: status,
        message: message
      }

      if @teacher_id
        notification_params[:teacher_id] = @teacher_id
      elsif @student_id
        notification_params[:student_id] = @student_id
      end

      notification = Notification.create!(notification_params)

      sleep 2
      ActionCable.server.broadcast('notifications_channel', { notification: notification })

      redis.set(notification_key, true)
      redis.expire(notification_key, 1.hour.to_i) # Set the key to expire after 1 hour to free up space
    end
  end
end
