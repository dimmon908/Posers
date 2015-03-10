class CreateForumabusereports < ActiveRecord::Migration
  def self.up
    create_table :forumabusereports do |t|
      t.column :message, :text
      t.column :user_id, :integer
      t.column :forummessage_id, :integer
      t.column :forumtopic_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :forumabusereports
  end
end
