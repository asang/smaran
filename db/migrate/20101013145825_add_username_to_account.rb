class AddUsernameToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :username, :string
  end

  def self.down
    remove_column :accounts, :username
  end
end
