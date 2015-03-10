class Addtitleprefab < ActiveRecord::Migration
  def self.up
    add_column :prefabmails, :title, :string
  end

  def self.down
  end
end
