class Manage::PapersController < ApplicationController
  before_action :authenticate_teacher!
  before_action :find_exam
  before_action :set_paper, only: [:show, :edit, :update, :destroy]

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @papers = @exam.papers.all.paginate(page: params[:page])
    @paper = Paper.new
    @question = Question.new
    respond_to do |format|
      format.html { }
      format.js { }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    @paper = Paper.new
    respond_to do |format|
      format.js { }
    end 
  end

  def edit
  end

  def create
    @paper = Paper.new(paper_params)
    @paper.exam = @exam
    @paper.account_id = @exam.account_id
    @paper.duration = @paper.duration*60
    respond_to do |format|
      if @paper.save
        @papers = @exam.papers.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Created', message: 'Successfully created paper' }
        format.js {}
      else
        flash.now[:error] = @paper.errors.full_messages
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to create paper' }
        format.js {}
      end
    end
  end

  def update
    respond_to do |format|
      if @paper.update(paper_params)
        @papers = @exam.papers.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Updated', message: 'Paper was successfully updated.' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to up update paper' }
        format.js {}
      end
    end
  end

  def destroy
    @paper.destroy
    respond_to do |format|
      @notification = { status: 'success', title: 'Deleted', message: 'Successfully deleted paper' }
      format.js { }
    end
  end

  private
    def find_exam
      @exam = Exam.where(:account_id => @current_account.id, :id => params[:exam_id]).first
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_paper
      @paper = Paper.where(:account_id => @current_account.id, :id => params[:id], :exam_id => params[:exam_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paper_params
      params.require(:paper).permit(:id, :name,:no_of_questions, :status,:duration, :marks_per_question, :negative_marks_per_question)
    end
end
