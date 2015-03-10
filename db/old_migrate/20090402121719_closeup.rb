class Closeup < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :closeup_id, :integer
  end

  def self.down
  end
end
