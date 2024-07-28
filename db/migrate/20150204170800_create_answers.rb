class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.integer :account_id
      t.integer :student_id
      t.integer :paper_session_id
      t.integer :question_id
      t.string :answer
      t.boolean :correct

      t.timestamps null: false
    end
  end
end
