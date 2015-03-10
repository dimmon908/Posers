class CreateAankoops < ActiveRecord::Migration
  def self.up
    create_table :aankoops do |t|
      t.column :user_id, :integer
      t.column :kunstvoorwerp_id, :integer
      t.column :prijs, :integer
      t.column :status, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :aankoops
  end
end
