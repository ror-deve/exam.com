require 'csv'

class ListImportService
  def initialize(file_path, model_attributes, account_id, options={})
    @file_path = file_path
    @model_attributes = model_attributes
    @account_id = account_id
    @options = options
  end

  def import_contact
    process_single_file(@file_path, @options)
  end

  private

  def process_single_file(file_path, options={})
    begin
      resp = S3_CLIENT.get_object(key: file_path, bucket: Rails.configuration.x.aws.bucket)
      # Parse the CSV data
      csv_data = resp.body.read
      csv_rows = CSV.parse(csv_data, headers: true)
      csv_rows.each do |row|
        record_attributes = build_record_attributes(row.to_hash)
        contact = find_or_create_contact(record_attributes)
        create_list_subscription(contact, options["list_id"])
      end
      delete_from_s3_bucket(file_path)
    rescue Exception => e
      Rails.logger.error("Error while file: #{e.message}")
    end
  end


  def build_record_attributes(csv_row)
    # Build the dynamic record attributes based on the provided model attributes
    # This method assumes that model_attributes is a hash where keys represent CSV column names
    # and values represent the corresponding model attribute names.

    record_attributes = {}

    @model_attributes.each do |csv_column, model_attribute|
      record_attributes[model_attribute.to_sym] = csv_row[csv_column]
    end
    record_attributes[:account_id] = @account_id
    record_attributes[:domain_name_id] = 1 # need to change this
    record_attributes
  end

  def find_or_create_contact(attributes)
    contact = Contact.find_by(account_id: @account_id, email: attributes[:email])

    # If contact does not exist, create a new one
    contact ||= Contact.create!(attributes)

    contact
  end

  def create_list_subscription(contact, list_id)
    unless list_id.present?
      raise "List Id not present! for #{contact.email}"
    end
    ls = ListSubscription.where(account_id: @account_id, list_id: list_id, contact_id: contact.id).first_or_initialize
    ls.active = true if ls.new_record?
    ls.save!
  end

  def delete_from_s3_bucket(key)
    begin
      S3_CLIENT.delete_object({
        bucket: Rails.configuration.x.aws.bucket, 
        key: key, 
      })
    rescue => e
      Rails.logger.error("Failed to delete s3 file: #{e.message}")
    end
  end
end
