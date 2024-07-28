class CreatePapers < ActiveRecord::Migration[5.2]
  def change
    create_table :papers do |t|
      t.string :name
      t.integer :account_id
      t.integer :exam_id
      t.integer :status
      t.integer :duration
      t.float :marks_per_question
      t.float :negative_marks_per_question

      t.timestamps null: false
    end
  end
end
