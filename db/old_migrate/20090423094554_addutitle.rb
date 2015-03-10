class Addutitle < ActiveRecord::Migration
  def self.up
    add_column :users, :utitle, :string, :default => "[nickname]"
    
  end

  def self.down
  end
end
