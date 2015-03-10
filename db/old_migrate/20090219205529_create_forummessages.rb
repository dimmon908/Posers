class CreateForummessages < ActiveRecord::Migration
  def self.up
    create_table :forummessages do |t|
      t.text     "raw"
      t.text     "processed"
      t.boolean  "locked",        :default => false
      t.boolean  "hidden",        :default => false
      t.integer  "user_id"
      t.integer  "forumtopic_id"
      t.integer  "report_count"
      t.boolean  "topicstart",    :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :forummessages
  end
end
