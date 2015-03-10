class Addwebsitefield < ActiveRecord::Migration
  def self.up
    add_column :users, :profile_website, :text
  end

  def self.down
  end
end
