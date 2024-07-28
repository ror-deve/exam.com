class CreateRelationshipTables < ActiveRecord::Migration[5.2]
  def change
    create_table :subjects_teachers, :id => false do |t|
      t.integer :subject_id
      t.integer :teacher_id
    end
    create_table :batches_exams, :id => false do |t|
      t.integer :batch_id
      t.integer :exam_id
    end
    create_table :exams_segments, :id => false do |t|
      t.integer :exam_id
      t.integer :segment_id
    end
    create_table :batches_papers, :id => false do |t|
      t.integer :batch_id
      t.integer :paper_id
    end
    create_table :papers_segments, :id => false do |t|
      t.integer :paper_id
      t.integer :segment_id
    end
    create_table :papers_topics, :id => false do |t|
      t.integer :paper_id
      t.integer :topic_id
    end
    create_table :streams_teachers, :id => false do |t|
      t.integer :stream_id
      t.integer :teacher_id
    end
    create_table :accounts_streams, :id => false do |t|
      t.integer :account_id
      t.integer :stream_id
    end
    create_table :papers_questions, :id => false do |t|
      t.integer :paper_id
      t.integer :question_id
    end
    create_table :streams_subjects, :id => false do |t|
      t.integer :steam_id
      t.integer :subject_id
    end
  end
end
