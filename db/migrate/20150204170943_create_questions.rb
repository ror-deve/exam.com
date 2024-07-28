class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :account_id
      t.integer :topic_id
      t.text :title
      t.string :option1
      t.string :option2
      t.string :option3
      t.string :option4
      t.string :option5
      t.string :answer
      t.float :marks
      t.float :negative_marks

      t.timestamps null: false
    end
  end
end
