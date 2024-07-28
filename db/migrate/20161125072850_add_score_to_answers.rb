class AddScoreToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :score, :float
  end
end
