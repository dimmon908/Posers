class SettingAvatarS3 < ActiveRecord::Migration
  def up
    change_table :avatars do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.datetime :image_updated_at
    end
    puts "Migrating data"
    Avatar.all.each do |avatar|
      attributes = { image_file_name: "0000_#{("%04d" % avatar.id)}_#{avatar.filename}",
      image_content_type: avatar.content_type, image_file_size: avatar.size, image_updated_at: Time.now }
      avatar.update_attributes attributes
    end
  end

  def down
    change_table :avatars do |t|
      t.remove :image_file_name
      t.remove :image_content_type
      t.remove :image_file_size
      t.remove :image_updated_at
    end
  end
end
