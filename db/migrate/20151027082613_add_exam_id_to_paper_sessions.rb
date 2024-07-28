class AddExamIdToPaperSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :paper_sessions, :exam_id, :integer
    add_index :paper_sessions, :exam_id
  end
end
