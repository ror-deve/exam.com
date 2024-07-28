class ExamSessionsController < ApplicationController
  before_action :authenticate_student!
  before_action :set_exam, only: [:show, :edit, :update, :destroy]

  def index
    @exam_sessions = current_student.exam_sessions.all
  end

  def show
    @exam_sessions = ExamSession.where(exam_id: params[:id]).order('score DESC')
  end

  def new
    @exam = current_student.exams.live.where(id: params[:exam_id]).includes(:papers).first
  end

  def create
    @exam = current_student.exams.live.where(id: params[:exam_id]).first
    @paper = @exam.papers.find_by(id: params[:paper_id])
    @paper_session = PaperSession.where(finished_at: nil).find_by(student_id: current_student.id)
    if @paper_session
      redirect_back(fallback_location: "/exams/1/papers", alert: 'You can not start this paper as you already have an unfinished paper.')
    else
      @paper_session = PaperSession.find_or_initialize_by(paper_id: @paper.id, student_id: current_student.id)
      @paper_session.paper_id = @paper.id
      @paper_session.exam_id = @exam.id
      @paper_session.account_id = @exam.account_id
      @paper_session.student_id = current_student.id
      @paper_session.started_at = Time.now
      @paper_session.score = 0
      if @paper_session.save
        session[:questions_left] = @paper_session.paper.no_of_questions
        redirect_to new_paper_session_answer_path(@paper_session)
      else
        redirect_back(fallback_location: "/exams/1/papers" , alert: "Error! #{@paper_session.errors.full_messages.join(', ')}")
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = current_student.exam_sessions.where(:id => params[:id]).first
    end
end
