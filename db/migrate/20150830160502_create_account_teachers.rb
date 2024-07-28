class CreateAccountTeachers < ActiveRecord::Migration[5.2]
  def change
    create_table :account_teachers do |t|
      t.integer :account_id
      t.integer :teacher_id
      t.boolean :admin

      t.timestamps null: false
    end
    add_index :account_teachers, :account_id
    add_index :account_teachers, :teacher_id
  end
end
