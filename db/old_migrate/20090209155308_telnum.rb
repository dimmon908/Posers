class Telnum < ActiveRecord::Migration
  def self.up
    add_column :users, :prive_telefoonnummer, :string
  end

  def self.down
  end
end
