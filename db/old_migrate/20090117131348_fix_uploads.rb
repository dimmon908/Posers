class FixUploads < ActiveRecord::Migration
  def self.up
    remove_column :kunstimages, :size
    remove_column :kunstimages, :height
    remove_column :kunstimages, :parent_id
    remove_column :kunstimages, :data
    remove_column :kunstimages, :db_file_id
    remove_column :kunstimages, :thumbnail
    
    add_column :kunstimages, :extension, :string
  end

  def self.down
  end
end
