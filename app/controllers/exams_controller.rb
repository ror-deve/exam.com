class ExamsController < ApplicationController
  before_action :authenticate_student!
  before_action :set_exam, only: [:show, :edit, :update, :destroy]

  # GET /exams
  # GET /exams.json
  def index
    @exams = current_student.exams.page(params[:page])
    @finished_exam_ids = ExamSession.where.not(finished_at: nil).where(student_id: current_student.id).pluck(:exam_id)
  end

  # GET /exams/1
  # GET /exams/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = current_student.exams.where(:id => params[:id]).first
    end
end
