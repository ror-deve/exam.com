class Manage::QuestionsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :find_paper
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @questions = @paper.questions.all.paginate(page: params[:page])
    @question = Question.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    @question = Question.new
    respond_to do |format| 
      format.js { }
    end 
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.account_id = @paper.account_id
    respond_to do |format|
      if @question.save
        @questions = @paper.questions.all.paginate(page: params[:page])
        @paper.questions << @question
        @notification = { status: 'success', title: 'Created', message: 'Question was successfully created.' }
        format.js {}
      else
        @errors = @question.errors.full_messages
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to create question'}
        format.js {}
      end
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        @questions = @paper.questions.all.paginate(page: params[:page])
        @notification = { status: 'success', title: 'Updated', message: 'Question was successfully updated.' }
        format.js {}
      else
        @notification = { status: 'error', title: 'Creation Failed', message: 'Failed to update question' }
        format.js {}
      end
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      @notification = { status: 'success', title: 'Deleted', message: 'Successfully deleted question' }
      format.js { }
    end
  end

  private
  def find_paper
    @exam = Exam.where(:account_id => @current_account.id, :id => params[:exam_id]).first
    @paper = Paper.where(:exam_id => @exam.id, :id => params[:paper_id]).first
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.where(:account_id => @current_account.id, :id => params[:id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def question_params
    hsh = params.require(:question).permit(:id, :title, :topic_id, :marks, :negative_marks, :option1, :option2, :option3, :option4, :option5, :answer)
    hsh[:answer] = params[:answers].select{|k,v| v == '1' }.keys if params[:answers].present?
    return hsh
  end
end
