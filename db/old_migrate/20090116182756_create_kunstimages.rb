class CreateKunstimages < ActiveRecord::Migration
  def self.up
    create_table :kunstimages do |t|
      t.column :kunstvoorwerp_id, :integer
      t.column :size,         :integer  # file size in bytes
      t.column :content_type, :string   # mime type, ex: application/mp3
      t.column :filename,     :string   # sanitized filename
      t.column :height,       :integer  # in pixels
      t.column :width,        :integer  # in pixels
      t.column :parent_id,    :integer  # id of parent image (on the same table, a self-referencing foreign-key).
      t.column :thumbnail,    :string   # the 'type' of thumbnail this attachment record describes.
      t.column :db_file_id,   :integer  # id of the file in the database (foreign key)

      t.column :data, :binary # binary file data, for use in database file storage
      t.timestamps
    end
  end

  def self.down
    drop_table :kunstimages
  end
end
