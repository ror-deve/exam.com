class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :subject_id

      t.timestamps null: false
    end
  end
end
