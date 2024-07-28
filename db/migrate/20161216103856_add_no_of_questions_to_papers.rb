class AddNoOfQuestionsToPapers < ActiveRecord::Migration[5.2]
  def change
    add_column :papers, :no_of_questions, :integer
  end
end
