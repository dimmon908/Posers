class Addmailingoption < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_maillist, :boolean, :default => true
  end

  def self.down
  end
end
