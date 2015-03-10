class CreateAbusereports < ActiveRecord::Migration
  def self.up
    create_table :abusereports do |t|
      t.column :message, :text
      t.column :user_id, :integer
      t.column :reply_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :abusereports
  end
end
