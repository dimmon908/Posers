class Fixback < ActiveRecord::Migration
  def self.up
	change_column :kunstvoorwerps, :prijs, :integer

  end

  def self.down
  end
end
