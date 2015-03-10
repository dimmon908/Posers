class Addintname < ActiveRecord::Migration
  def self.up
    add_column :users, :intname, :string
  end

  def self.down
  end
end
