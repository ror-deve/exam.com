class CreateSegments < ActiveRecord::Migration[5.2]
  def change
    create_table :segments do |t|
      t.string :name
      t.integer :account_id
      t.boolean :match_all
      t.integer :students_count

      t.timestamps null: false
    end
  end
end
