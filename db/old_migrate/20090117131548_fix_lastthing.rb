class FixLastthing < ActiveRecord::Migration
  def self.up
    remove_column :kunstimages, :width
  end

  def self.down
  end
end
