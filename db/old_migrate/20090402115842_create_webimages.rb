class CreateWebimages < ActiveRecord::Migration
  def self.up
    create_table :webimages do |t|
      t.column :content_type, :string
      t.column :filename, :string
      t.column :size, :integer
      t.column :thumbnail, :string
      t.column :width, :integer
      t.column :height, :integer
      t.column :parent_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :webimages
  end
end
