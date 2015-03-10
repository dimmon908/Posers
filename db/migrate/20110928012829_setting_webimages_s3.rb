class SettingWebimagesS3 < ActiveRecord::Migration
  def up
    change_table :webimages do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.datetime :image_updated_at
    end
    puts "Migrating data"
    Webimage.all.each do |webimage|
      attributes = { image_file_name: "0000_#{("%04d" % webimage.id)}_#{webimage.filename}",
      image_content_type: webimage.content_type, image_file_size: webimage.size, image_updated_at: Time.now }
      webimage.update_attributes attributes
    end
  end

  def down
    change_table :webimages do |t|
      t.remove :image_file_name
      t.remove :image_content_type
      t.remove :image_file_size
      t.remove :image_updated_at
    end
  end
  
end
