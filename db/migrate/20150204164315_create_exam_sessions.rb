class CreateExamSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :exam_sessions do |t|
      t.integer :account_id
      t.integer :exam_id
      t.integer :student_id
      t.integer :time_taken
      t.float :max_marks
      t.float :percentage
      t.float :score
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps null: false
    end
  end
end
