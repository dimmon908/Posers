class Add2d3d < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :dimensie, :integer
  end

  def self.down
    drop_column :kunstvoorwerps, :dimensie
  end
end
