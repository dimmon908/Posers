class Fixprice < ActiveRecord::Migration
  def self.up
    change_column :kunstvoorwerps, :prijs, :float
    
  end

  def self.down
  end
end
