class Addkunstvoorwerpid < ActiveRecord::Migration
  def self.up
    add_column :abusereports, :kunstvoorwerp_id, :integer
  end

  def self.down
  end
end
