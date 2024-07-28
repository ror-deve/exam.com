class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :account_id
      t.integer :batch_id
      t.integer :student_id
      t.string :roll_number

      t.timestamps null: false
    end
  end
end
