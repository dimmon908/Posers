class Addintmailvars < ActiveRecord::Migration
  def self.up
    add_column :intmails, :vars, :text
    
  end

  def self.down
  end
end
