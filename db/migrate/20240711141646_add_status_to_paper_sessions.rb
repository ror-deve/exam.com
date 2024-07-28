class AddStatusToPaperSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :paper_sessions, :status, :string
  end
end
