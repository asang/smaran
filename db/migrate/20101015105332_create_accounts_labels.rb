class CreateAccountsLabels < ActiveRecord::Migration
  def self.up
    create_table :accounts_labels, :id => false do |t|
      t.integer :account_id
      t.integer :label_id
    end
  end

  def self.down
    drop_table :accounts_labels
  end
end
