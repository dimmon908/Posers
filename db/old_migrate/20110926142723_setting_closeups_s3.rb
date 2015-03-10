class SettingCloseupsS3 < ActiveRecord::Migration
  def up
    change_table :closeups do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.datetime :image_updated_at
    end
    puts "Migrating data"
    Closeup.all.each do |closeup|
      attributes = { image_file_name: "0000_#{("%04d" % closeup.id)}_#{closeup.filename}",
      image_content_type: closeup.content_type, image_file_size: closeup.size, image_updated_at: Time.now }
      closeup.update_attributes attributes
    end
  end

  def down
    change_table :closeups do |t|
      t.remove :image_file_name
      t.remove :image_content_type
      t.remove :image_file_size
      t.remove :image_updated_at
    end
  end
end
