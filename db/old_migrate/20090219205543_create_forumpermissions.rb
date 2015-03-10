class CreateForumpermissions < ActiveRecord::Migration
  def self.up
    create_table :forumpermissions do |t|
      t.string   "title"
      t.string   "action"
      t.string   "mode"
      t.integer  "parent_id"
      t.integer  "role_id"
      t.boolean  "can",        :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :forumpermissions
  end
end
