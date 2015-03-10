class CreateMassmails < ActiveRecord::Migration
  def self.up
    create_table :massmails do |t|
      t.column :title, :text
      t.column :message, :text
      t.column :user_id, :integer
      t.column :sent, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :massmails
  end
end
