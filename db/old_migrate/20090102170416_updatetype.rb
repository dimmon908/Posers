class Updatetype < ActiveRecord::Migration
  def self.up
    add_column :types, :title, :string
  end

  def self.down
    remove_column :types, :title
  end
end
