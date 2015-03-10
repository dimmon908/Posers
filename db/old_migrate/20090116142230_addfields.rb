class Addfields < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :prijs, :integer
  end

  def self.down
    remove_column :kuntsvoorwerps, :prijs
  end
end
