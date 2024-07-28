class CreateExams < ActiveRecord::Migration[5.2]
  def change
    create_table :exams do |t|
      t.integer :account_id
      t.string :name
      t.integer :status
      t.integer :duration
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
