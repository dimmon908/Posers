class Add2d3d2 < ActiveRecord::Migration
  def self.up
    remove_column :kunstvoorwerps, :dimensie
    add_column :types, :dimensie, :integer
  end

  def self.down
  end
end
