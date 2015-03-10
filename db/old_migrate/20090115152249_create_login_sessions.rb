class CreateLoginSessions < ActiveRecord::Migration
  def self.up
    create_table :login_sessions do |t|
      t.integer  "user_id"
      t.string   "authentication_key"
      t.timestamps
    end
  end

  def self.down
    drop_table :login_sessions
  end
end
