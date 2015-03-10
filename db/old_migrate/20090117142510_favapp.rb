class Favapp < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :favcount, :integer, :default => 0
    add_column :kunstvoorwerps, :appcount, :integer, :default => 0
  end

  def self.down
  end
end
