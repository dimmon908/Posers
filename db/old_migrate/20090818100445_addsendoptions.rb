class Addsendoptions < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :verzendmethode, :integer, :default => 0
    
  end

  def self.down
  end
end
