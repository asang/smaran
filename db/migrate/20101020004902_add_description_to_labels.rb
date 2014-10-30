class AddDescriptionToLabels < ActiveRecord::Migration
  def self.up
    add_column :labels, :description, :string, :default => '-'
  end

  def self.down
    remove_column :labels, :description
  end
end
