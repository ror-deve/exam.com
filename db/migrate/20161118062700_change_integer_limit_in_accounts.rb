class ChangeIntegerLimitInAccounts < ActiveRecord::Migration[5.2]
  def change
    change_column :accounts, :phone, :integer, limit: 8
  end
end
