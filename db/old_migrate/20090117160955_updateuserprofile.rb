class Updateuserprofile < ActiveRecord::Migration
  def self.up
    add_column :users, :profile_description, :text
    add_column :users, :profile_disciplines, :text
    add_column :users, :prive_bankrek, :text
  end

  def self.down
  end
end
