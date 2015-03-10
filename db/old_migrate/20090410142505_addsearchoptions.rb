class Addsearchoptions < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :views, :integer, :default => 0
    add_column :kunstvoorwerps, :reacties, :integer, :default => 0
  end

  def self.down
  end
end
