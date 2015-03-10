class CreateKunstvoorwerps < ActiveRecord::Migration
  def self.up
    create_table :kunstvoorwerps do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :sfield, :text
      t.column :tags, :text
      t.column :width, :integer
      t.column :height, :integer
      t.column :user_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :kunstvoorwerps
  end
end
