class CreateForumreports < ActiveRecord::Migration
  def self.up
    create_table :forumreports do |t|
      t.string   "title"
      t.text     "message"
      t.integer  "user_id"
      t.integer  "forummessage_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :forumreports
  end
end
