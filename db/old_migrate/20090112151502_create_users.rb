class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   "nickname"
      t.string   "email"
      t.string   "original_email"
      t.string   "password"
      t.integer  "userrole_id"
      t.string   "ip"
      t.boolean  "activated"
      t.string   "unid"
      t.integer  "role_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
