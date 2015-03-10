class Addm < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :depth, :integer, :default => 0
    add_column :kunstvoorwerps, :material, :string
    
  end

  def self.down
  end
end
