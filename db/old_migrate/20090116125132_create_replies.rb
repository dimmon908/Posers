class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.integer :kunstvoorwerp_id
      t.integer :user_id
      t.text    :raw
      t.text    :processed
      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end
