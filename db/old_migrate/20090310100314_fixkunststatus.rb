class Fixkunststatus < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :status, :integer, :default => 0
  end

  def self.down
  end
end
