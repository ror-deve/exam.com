class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :email
      t.integer :phone
      t.string :address
      t.integer :owner_id

      t.timestamps null: false
    end
  end
end
