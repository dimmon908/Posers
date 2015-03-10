class Addkvops < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :verkocht, :boolean, :default => false
    add_column :kunstvoorwerps, :houmeopdehoogte, :boolean, :default => false
  end

  def self.down
  end
end
