# Clear existing data
puts 'Clearing existing data...'
AccountTeacher.destroy_all
Answer.destroy_all
ExamSession.destroy_all
PaperSession.destroy_all
Subscription.destroy_all
Batch.destroy_all
Exam.destroy_all
Paper.destroy_all
Question.destroy_all
Segment.destroy_all
Stream.destroy_all
Student.destroy_all
Subject.destroy_all
Teacher.destroy_all
Account.destroy_all

# Create sample accounts
puts 'Creating sample data...'
# Create Admin User
admin_user_data = { email: 'admin@pariksha24.com', password: 'Master123#', password_confirmation: 'Master123#' }
admin_user = AdminUser.where(email: admin_user_data[:email]).first_or_create(admin_user_data)
puts "> Admin User:"
puts "> Email: #{admin_user.email}"
puts "> Password: #{admin_user_data[:password]}"
puts ""

5.times do |i|
  # Create account 
  owner = Teacher.create!(name: "Teacher #{i+1}", email: "teacher#{i+1}@pariksha24.com", phone: "123456789#{i+1}", password: 'password', password_confirmation: 'password')
  puts "> Teacher:"
  puts "> Name: #{owner.name}"
  puts "> Email: #{owner.email}"
  puts "> password: #{owner.password}"

  account = Account.create!(name: "Account #{i+1}", email: "account#{i+1}@pariksha24.com", phone: "987654321#{i+1}", address: "Address #{i+1}", owner: owner)
  # Create batches
  5.times do |j|
    batch = Batch.create!(
      name: "Batch #{i * 5 + j + 1}",
      account: account
    )

    # Create exams
    5.times do |k|
      exam = Exam.create!(name: "Exam #{i * 25 + j * 5 + k + 1}", duration: 120, start_time: Time.now, end_time: Time.now + 2.hours, account: account, batch: batch)

      # Create students
      5.times do |l|
        student = Student.create!(name: "Student #{i * 125 + j * 25 + k * 5 + l + 1}", email: "student#{i * 125 + j * 25 + k * 5 + l + 1}@example.com", phone: "111111111#{i * 125 + j * 25 + k * 5 + l + 1}", password: 'password', password_confirmation: 'password')
        Subscription.create!(account: account, student: student, batch: batch)
      end
    end
  end
end

5.times do |i|
  puts 'Creating streams...'
  streams = []
  5.times do |i|
    streams << Stream.create!(name: "Stream #{i+1}")
  end

  # Create subjects
  puts 'Creating subjects...'
  subjects = []
  5.times do |i|
    subject = Subject.create!(name: "Subject #{i+1}")
    subjects << subject
    streams.each do |stream|
      subject.streams << stream
    end
  end

  # Create topics
  puts 'Creating topics...'
  topics_data = [
    { name: "Topic 1" },
    { name: "Topic 2" },
    { name: "Topic 3" },
    { name: "Topic 4" },
    { name: "Topic 5" },
  ]

  subjects.each do |subject|
    topics_data.each do |topic_data|
      topic = subject.topics.find_or_initialize_by(name: topic_data[:name])
      topic.save!
    end
  end
end

accounts = Account.all
subjects = Subject.all

# Create questions
puts 'Creating questions...'
questions = []
5.times do |i|
  subject = subjects[i]
  topic = subject.topics.first
  questions << Question.create!(title: "Question #{i+1}", answer: "Answer is #{i+1}", topic: topic, account: accounts[i], option1: "Option 1 for Question #{i+1}", option2: "Option 2 for Question #{i+1}", option3: "Option 3 for Question #{i+1}", option4: "Option 4 for Question #{i+1}", option5: "Option 5 for Question #{i+1}")
end

# Create papers
puts 'Creating papers...'
papers = []
5.times do |i|
  exams = accounts[i].exams
  if exams.any?
    exam = exams.first
    papers << Paper.create!(name: "Paper #{i+1}", duration: 60, status: 'active', account: accounts[i], exam_id: exam.id, negative_marks_per_question: 0)
  else
    puts "No exams found for account #{accounts[i].id}"
  end
end

# Create segments
puts 'Creating segments...'
segments = []
5.times do |i|
  segments << Segment.create!(
    name: "Segment #{i+1}",
    account: accounts[i]
  )
end

accounts = Account.all
batches = Batch.all
topics = Topic.all

# Create exams for each account
puts 'Creating exams...'
accounts.each do |account|
  5.times do |i|
    exam = Exam.create!(name: "Exam #{i+1}", duration: 120, start_time: Time.now, end_time: Time.now + 2.hours, account: account, batch: batches.sample)

    # Create papers and questions for each exam
    5.times do |j|
      paper = Paper.create!(name: "Paper #{j+1} for Exam #{exam.id}", duration: 60, status: 'active', account: account, exam: exam, negative_marks_per_question: 0)
      5.times do |k|
        topic = topics.sample
        question = Question.create!(title: "Question #{k+1} for #{topic.name}", answer: "Answer #{k+1} for #{topic.name}", topic: topic, account: account, option1: "Option 1 for Question #{k+1} in #{topic.name}", option2: "Option 2 for Question #{k+1} in #{topic.name}", option3: "Option 3 for Question #{k+1} in #{topic.name}", option4: "Option 4 for Question #{k+1} in #{topic.name}", option5: "Option 5 for Question #{k+1} in #{topic.name}")
        paper.questions << question
      end
    end
  end
end

puts 'Creating paper sessions...'
paper_sessions = []
exam_sessions = ExamSession.all

5.times do |i|
  paper = Paper.find_by(id: i+1)
  exam_session = exam_sessions[i]

  if paper && exam_session
    account = Account.first
    student = Student.first
    paper_sessions << PaperSession.create!(account: account, student: student, paper: paper, exam_session: exam_session, exam_id: exam_session.exam_id, score: rand(0..100), max_marks: 100)
  end
end

puts 'Creating answers...'
5.times do |i|
  paper_session = paper_sessions[i]
  if paper_session
    Answer.create!(account: Account.first, student: Student.first, paper_session: paper_session, question: Question.first, answer: "Answer for Question #{i+1}")
  end
end

# Create data for accounts and teachers
puts 'Creating AccountTeacher associations...'
Account.find_each do |account|
  teachers = Teacher.all.sample(5)
  teachers.each do |teacher|
    AccountTeacher.create!(account: account, teacher: teacher)
  end
end
puts 'Seed data created successfully!'
