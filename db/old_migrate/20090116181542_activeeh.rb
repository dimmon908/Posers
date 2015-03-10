class Activeeh < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :active, :boolean, :default => false
  end

  def self.down
    remove_column :kunstvoorwerps, :active
  end
end
