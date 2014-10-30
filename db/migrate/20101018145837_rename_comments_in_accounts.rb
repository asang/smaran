class RenameCommentsInAccounts < ActiveRecord::Migration
  def self.up
    rename_column(:accounts, :comments, :encrypted_comments)
  end

  def self.down
    rename_column(:accounts, :encrypted_comments, :comments)
  end
end
