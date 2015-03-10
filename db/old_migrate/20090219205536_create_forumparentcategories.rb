class CreateForumparentcategories < ActiveRecord::Migration
  def self.up
    create_table :forumparentcategories do |t|
      t.string   "title"
      t.text     "description"
      t.integer  "category_count"
      t.integer  "user_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :forumparentcategories
  end
end
