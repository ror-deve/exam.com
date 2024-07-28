class PaperSession < ActiveRecord::Base
  belongs_to :account
  belongs_to :student
  belongs_to :paper
  belongs_to :exam_session
  has_many :questions, :through => :paper
  has_many :answers
  audited

  validates :account_id, :presence => true
  validates :student_id, :presence => true
  validates :paper_id,   :presence => true
  validates :exam_id,   :presence => true
  
  before_create do
    es = ExamSession.where(exam_id: exam_id).find_or_initialize_by(student_id: student_id)
    es.exam_id = exam_id
    es.account_id = account_id
    es.student_id = student_id
    es.started_at = Time.zone.now
    es.score = score
    es.save!

    self.exam_session_id = es.id
  end
  
  def finished?
    finished_at.present?
  end

  def next_question
    ques_ids = answers.pluck(:question_id)
    if ques_ids.present?
      return questions.where("questions.id not in (?)", ques_ids).sample
    else
      return questions.first
    end
  end


  def end_session
    @paper_session = PaperSession.where(exam_session_id: exam_session_id, student_id: student_id).find_by(paper_id: paper_id)
    update_attributes(finished_at: Time.zone.now, time_taken: Time.zone.now - (@paper_session.started_at))
    pscount = PaperSession.where(exam_session_id: id, student_id: student_id).where('finished_at is not null').count
    pcount = Paper.where(exam_id: id).count
    if pscount >= pcount
      ExamSession.where(exam_id: exam_id).find_by(student_id: student_id).end_session
    end
  end
end
