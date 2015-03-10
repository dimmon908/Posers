class CreateAankoopberichts < ActiveRecord::Migration
  def self.up
    create_table :aankoopberichts do |t|
      t.column :user_id, :integer
      t.column :kunstvoorwerp_id, :integer
      t.column :message, :text
      t.column :sentto, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :aankoopberichts
  end
end
