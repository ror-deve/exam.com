class AnswersController < ApplicationController
  before_action :authenticate_student!
  before_action :find_paper_session
  layout 'answers'
  
  @@correct_count = 0
  @@negative_count = 0
  @@quit = 0
  $c = 0
  @@serial_no = 1
  def new
    @paper = Paper.find_by(id: @paper_session.paper_id)
    @finish_time = @paper_session.started_at + (@paper.duration)
    @no_of_questions = @paper.no_of_questions
    if @paper_session 
      if (@@serial_no <= @no_of_questions) && (Time.zone.now <= @finish_time)
        @question = @paper_session.next_question
        $c += 1
        @@serial_no += 1
      else
        @question = nil
        @@serial_no = 1
      end
      if @question.blank? || @@quit == 1
        @paper_session.score = (@@correct_count * @paper.marks_per_question) + (@@negative_count * @paper.negative_marks_per_question)
        @paper_session.percentage = ((@paper_session.score/(@paper.no_of_questions * @paper.marks_per_question)) * 100).round(2)
        @paper_session.max_marks = @paper.no_of_questions * @paper.marks_per_question
        @paper_session.end_session
        @@correct_count = 0
        @@negative_count = 0
        @@quit = 0
        $c = 0
        redirect_to exam_papers_path(@paper_session.exam_id), notice: 'Paper has finished.'
      end
    else
      redirect_to exams_path, alert: 'Error! Unable to find paper.'
    end
  end

  def create
    @answer = Answer.where(paper_session_id: @paper_session.id, question_id: params[:question_id])
    .find_by(student_id: current_student.id)
    if @time_left == 0
      flash[:alert] = "paper finish."
    elsif @time_left <= 300
      flash[:alert] = "Less than 5 minutes remaining on the clock be quick."
    end
    unless @answer
      @answer = Answer.new
      @answer.account_id = @paper_session.account_id
      @answer.student_id = current_student.id
      @answer.paper_session_id = @paper_session.id
      @answer.question_id = params[:question_id]
      @answer.answer = params[:answer]
      if @answer.answer.present?
        if params[:correct_answer].include?(@answer.answer)
          @answer.correct = 1
          @@correct_count += 1
        else
          @answer.correct = 0
          @@negative_count += 1
        end
      else
        @answer.correct = 0
      end
      if params[:commit] == "Skip Question"
      @answer.save(validate: false)
      session[:questions_left] = session[:questions_left] - 1
      else
        @answer.save
        session[:questions_left] = session[:questions_left] - 1
      end
    end
    if params[:commit] == "Quit Paper"
      @@quit = 1
    end
    redirect_to new_paper_session_answer_path(@paper_session)
  end

  private
  
  def finish_exam msg="Exam finished successfully."
    @question = nil
    new
  end
  
  def find_paper_session
    @paper_session = PaperSession.where(student_id: current_student.id, finished_at: nil).find_by(id: params[:paper_session_id])
    @time_left = (@paper_session.paper.duration - (Time.now - @paper_session.started_at)).to_i
  end
end
