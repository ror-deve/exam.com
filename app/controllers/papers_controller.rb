class PapersController < ApplicationController
  before_action :authenticate_student!
  before_action :find_exam
  before_action :set_paper, only: [:show, :start_exam, :question, :exit_exam]

  def index
    @papers = @exam.papers.all
    @finished_paper_ids = PaperSession.where.not(finished_at: nil).where(exam_id: @exam.id, student_id: current_student.id).pluck(:paper_id)
  end

  def score_card
    student_id = params[:student_id]
    exam_id = params[:exam_id]
    paper_id = params[:id]

    @paper_session = PaperSession.find_by(student_id: student_id, exam_id: exam_id, paper_id: paper_id)
    if @paper_session.nil?
      redirect_to pending_student_exam_papers_path, alert: "Paper session not found."
    else
      @paper = @paper_session.paper
    end
  end

  def start_exam
    @student = Student.find(params[:student_id])
    @exam = Exam.find(params[:exam_id])
    @paper = Paper.find(params[:id])
    @account = @paper.account_id

    @exam_session = ExamSession.find_or_create_by(student_id: @student.id, exam_id: @exam.id, account_id: @account) do |session|
      session.started_at = Time.now
    end

    unless @exam_session.started_at
      @exam_session.update(started_at: Time.now)
    end

    @paper_session = PaperSession.find_or_initialize_by(
      account_id: @paper.account_id,
      student_id: @student.id,
      paper_id: @paper.id,
      exam_id: @exam.id,
      exam_session_id: @exam_session.id
    )
  
    @paper_session.answers.update_all(correct: false)
  
    @paper_session.started_at = Time.now
    @paper_session.finished_at = nil
    @paper_session.time_taken = nil
    @paper_session.save!
  
    @questions = @paper.questions
    @time_remaining = @paper.duration
  
    session[:selected_answers] = {}
    session[:all_selected_answers] = []
  
    redirect_to question_student_exam_paper_path(@student, @exam, @paper)
  end

  def question
    object_params

    @question_number = params[:question_number].to_i
    @question_number = 1 if @question_number < 1
    @question = @questions[@question_number - 1] # Adjust index for zero-based array

    all_selected_answers = session[:all_selected_answers] || []
  
    @selected_answers = session[:selected_answers] ||= {}

    if @time_remaining <= 0    
      check_selected_answer(all_selected_answers)
      update_session(all_selected_answers)
      redirect_to student_exam_papers_path(@paper), notice: "Time is up! Your exam has been automatically submitted."
      return
    end

    if request.post?
      check_selected_answer(all_selected_answers)

      if @question_number < @questions.count
        redirect_to question_student_exam_paper_path(@student, @exam, @paper, question_number: @question_number + 1)
      else
        update_session(all_selected_answers)
        redirect_to student_exam_papers_path(@paper), notice: "Test Completed"
      end
    else
      @paper_session.save! if @paper_session.new_record?
    end
  end

  def exit_exam
    object_params

    all_selected_answers = session[:all_selected_answers] || []

    check_selected_answer(all_selected_answers)
    update_session(all_selected_answers)
    
    redirect_to student_exam_papers_path(@paper), notice: "You have exited the exam. Your progress has been saved."
  end

  def pending
    @pending_paper_sessions = PaperSession.where(status: 'pending', student_id: current_student.id)
  end

  def complete
    @complete_paper_sessions = PaperSession.where(status: 'complete', student_id: current_student.id)
  end
  private

  def find_exam
    @exam = current_student.exams.where(:id => params[:exam_id]).first
  end

  def set_paper
    @paper = @exam.papers.where(:id => params[:id]).first
  end

  def object_params
    @student = Student.find(params[:student_id])
    @exam = Exam.find(params[:exam_id])
    @paper = Paper.find(params[:id])
    @questions = @paper.questions.includes(:topic)
    @account = @paper.account_id
    @exam_session = ExamSession.find_or_create_by(account_id: @account, exam_id: @exam.id, student_id: @student.id)
    @paper_session = PaperSession.find_or_initialize_by(
      account_id: @account,
      student_id: @student.id,
      paper_id: @paper.id,
      exam_id: @exam.id,
      exam_session_id: @exam_session.id
    )
    
    @paper_duration = @paper.duration || 60
    @start_time = @paper_session.started_at || Time.now
    @paper_session.started_at ||= @start_time
    @time_remaining = (@start_time + @paper_duration - Time.now).to_i
  end

  def check_selected_answer(all_selected_answers)
    @selected_answers = params[:answers] || {}
    @selected_answers = params.require(:answers).permit!.to_h if @selected_answers.present?
    correct_answers_count = 0
    total_marks = 0

    @selected_answers.each do |question_id, selected_option|
      question = Question.find(question_id)
      answer_record = @paper_session.answers.find_or_initialize_by(question_id: question_id)
      answer_record.student_id = @student.id
      answer_record.account_id = @account
      answer_record.answer = selected_option
      answer_record.correct = (selected_option == question.answer)
      answer_record.save!

      if answer_record.correct
        correct_answers_count += 1
        total_marks += question.marks || 0
      end

      all_selected_answers << {
        question_id: question_id,
        selected_option: selected_option
      }

      session[:selected_answers][question_id] = selected_option
    end
    
    unique_ids = all_selected_answers.each_with_object({}) do |hash, result|
      result[hash["question_id"]] = hash
    end.values
    
    session[:all_selected_answers] = unique_ids
  end

  def update_session(all_selected_answers)
    if @time_remaining <= 0
      @time_remaining = 0
      time_taken = @paper_duration
      finished_at = @start_time + @paper_duration
    else
      time_taken = Time.now - @start_time
      finished_at = Time.now
    end
    correct_answers_count = @paper_session.answers.where(correct: true).count
    correct_marks = correct_answers_count * @paper.marks_per_question 
    total_marks = @paper.questions.count * @paper.marks_per_question
    percentage = ((correct_marks.to_f / total_marks) * 100).round(2)
    status = paper_session_status(all_selected_answers, @questions.count)
    session.delete(:all_selected_answers)
    @paper_session.update!(
      time_taken: time_taken,
      finished_at: finished_at,
      score: correct_marks,
      status: status,
      percentage: percentage
    )
  end

  def paper_session_status(selected_answers, questions_count)
    answered_questions_count = selected_answers.size
    if answered_questions_count == questions_count
      'complete'
    else
      'pending'
    end
  end
end
