class CreateBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :batches do |t|
      t.integer :account_id
      t.string :name

      t.timestamps null: false
    end
  end
end
