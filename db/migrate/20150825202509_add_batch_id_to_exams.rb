class AddBatchIdToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :batch_id, :integer
    add_index :exams, :batch_id
  end
end
