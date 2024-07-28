class Manage::StudentsController < ApplicationController
  respond_to :json, :xml, :html, :js
  before_action :authenticate_teacher!
  before_action :find_batch
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    respond_to do |format|
      if params[:query]
        @students = @batch.students.search_by_name_or_email(params[:query]).paginate(page: params[:page])
      else
        @students = @batch.students.all.paginate(page: params[:page])
      end
      format.html { }
      format.js { }
    end
    @student = Student.new
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    @student = Student.new
    respond_to do |format|
      format.js { }
    end
  end

  # GET /subscriptions/1/edit
  def edit
  end

  def create
    @student = Student.new(student_params)
    @student.password = '123456789'
    @student.password_confirmation = '123456789'

    respond_to do |format|
      if @student.save && @subscription = Subscription.where(:batch_id => @batch.id, :student_id => @student.id, :account_id => @batch.account_id).first_or_create
        @students = @batch.students.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Created', message: 'Successfully created student' }
        format.js { render :create }
      else
        @errors = @student.errors.full_messages
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to create student' }
        format.js {}
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @batch.subscriptions.where(:student_id => @student.id).first.try(:destroy)
    respond_to do |format|
      @notification = { status: 'success', title: 'Deleted', message: 'Successfully deleted student' }
      format.js { }
    end
  end

  def import
    if params[:file].present?
      begin
        file_path = params[:file].read
        job_argument = { "file_path" => file_path, "batch_id" => params[:batch_id].to_i, "teacher_id" => current_teacher.id }
        CsvProcessorJob.perform_async('import', job_argument)
        @notification = { status: 'success', title: 'CSV Import Started', message: 'CSV import started. You will be notified when it is done.' }
      rescue => e
        @notification = { status: 'error', title: 'Error Processing CSV', message: "Error processing CSV file: #{e.message}" }
      end
    else
      @notification = { status: 'error', title: 'No CSV File', message: 'Please upload a CSV file.' }
    end

    respond_to do |format|
      format.js
    end
  end

  def export
    batch_id = params[:batch_id]
    @file_path = Student.export_to_csv(batch_id)
    CsvProcessorJob.perform_async('export', "teacher_id" => current_teacher.id)
    
    respond_to do |format|
      @notification = { status: 'success', title: 'CSV export started', message: 'You will be notified when it is done.' }
      format.js
    end
  end

  def download_csv
    file_path = params[:file_path]

    unless file_path.end_with?(".csv")
      file_path += ".csv"
    end
    send_file(file_path, type: 'text/csv', disposition: 'attachment')
  end

  def download_sample
    send_file(
      "#{Rails.root}/public/sample/Student-sample-Template.csv",
      filename: "Student-sample-Template.csv",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  private
    def find_batch
      @batch = Batch.where(:account_id => @current_account.id, :id => params[:batch_id]).first
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = @batch.students.where(:id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :email, :phone, :address, :password)
    end
end
