class RenameUrlInAccount < ActiveRecord::Migration
  def self.up
    rename_column :accounts, :url, :encrypted_url
  end

  def self.down
    rename_column :accounts, :encrypted_url, :url
  end
end
