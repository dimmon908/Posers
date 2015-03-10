class CreateForumtopics < ActiveRecord::Migration
  def self.up
    create_table :forumtopics do |t|
      t.text     "title"
      t.string   "ttype"
      t.boolean  "locked"
      t.integer  "forumcategory_id"
      t.integer  "user_id"
      t.integer  "message_count",           :default => 0
      t.integer  "lastreply_user_id",       :default => 0
      t.datetime "lastreply_user_datetime"
      t.integer  "message_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :forumtopics
  end
end
