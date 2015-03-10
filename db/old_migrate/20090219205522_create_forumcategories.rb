class CreateForumcategories < ActiveRecord::Migration
  def self.up
    create_table :forumcategories do |t|
      t.string   "title"
      t.text     "description"
      t.integer  "forumparentcategory_id"
      t.integer  "user_id"
      t.integer  "messages_count",         :default => 0
      t.integer  "topics_count",           :default => 0
      t.integer  "lastreply_user_id",      :default => 0
      t.text     "moderators"
      t.datetime "lastreply_at"
      t.text     "short"
      t.integer  "maxwarnings"
      t.integer  "warnings"
      t.timestamps
    end
  end

  def self.down
    drop_table :forumcategories
  end
end
