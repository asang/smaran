class RenamePasswordInAccounts < ActiveRecord::Migration
  def self.up
    AccountsLabels.delete_all
    Account.delete_all
    rename_column :accounts, :password, :encrypted_password
  end

  def self.down
    rename_column :accounts, :encrypted_password, :password
  end
end
