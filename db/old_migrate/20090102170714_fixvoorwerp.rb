class Fixvoorwerp < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :type_id, :integer
  end

  def self.down
    remove_column :kunstvoorwerps, :type_id
  end
end
