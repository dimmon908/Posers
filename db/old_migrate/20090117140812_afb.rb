class Afb < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :kunstimage_id, :integer
  end

  def self.down
  end
end
