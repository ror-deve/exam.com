class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :student, foreign_key: { to_table: :students }
      t.references :teacher, foreign_key: { to_table: :teachers }
      t.string  :job_id
      t.string  :status
      t.text    :message
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
