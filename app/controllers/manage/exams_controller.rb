class Manage::ExamsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :set_exam, only: [:show, :edit, :update, :destroy]
  respond_to :json, :xml, :html, :js

  # GET /exams
  # GET /exams.json
  def index
    respond_to do |format|
      if params[:query]
        @exams = Exam.where(account_id: @current_account.id).search_by_name(params[:query]).paginate(page: params[:page])
      else
        @exams = Exam.where(account_id: @current_account.id).paginate(page: params[:page])
      end
      format.html
      format.js
    end
    @exam = Exam.new
    @question = Question.new
    @paper = Paper.new
  end

  # GET /exams/1
  # GET /exams/1.json
  def show
  end

  # GET /exams/new
  def new
    @exam = Exam.new
    respond_to do |format|
      format.js { }
    end 
  end

  # GET /exams/1/edit
  def edit
    respond_to do |format|
      format.js { }
    end
  end

  # POST /exams
  # POST /exams.json
  def create
    @exam = Exam.new(exam_params)
    @exam.account_id = @current_account.id

    respond_to do |format|
      if @exam.save
        @exams = Exam.where(account_id: @current_account.id).paginate(page: params[:page])
        @current_account.exams << @exam
        @notification = { status: 'success', title: 'Created', message: 'Successfully created exam' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to create exam' }
        format.js {}
      end
    end
  end

  def update
    respond_to do |format|
      if @exam.update(exam_params)
        @exams = Exam.where(account_id: @current_account.id).paginate(page: params[:page])
        @current_account.exams << @exam
        @notification = { status: 'success', title: 'Updated', message: 'Successfully updated exam' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to update exam' }
        format.js { }
      end
    end
  end

  # DELETE /exams/1
  # DELETE /exams/1.json
  def destroy
    respond_to do |format|
      if @exam.destroy
        @notification = { status: 'success', title: 'Deleted', message: 'Exam deleted successfully' }
        format.js { }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.where(:account_id => @current_account.id, :id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params.require(:exam).permit(:id, :name, :duration, :start_time, :end_time, :batch_id)
    end
end
