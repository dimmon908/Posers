class SettingInterieurS3 < ActiveRecord::Migration
  def up
    change_table :interieurs do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.datetime :image_updated_at
    end
    puts "Migrating data"
    Interieur.all.each do |interieur|
      attributes = { image_file_name: "0000_#{("%04d" % interieur.id)}_#{interieur.filename}",
      image_content_type: interieur.content_type, image_file_size: interieur.size, image_updated_at: Time.now }
      interieur.update_attributes attributes
    end
  end

  def down
    change_table :interieurs do |t|
      t.remove :image_file_name
      t.remove :image_content_type
      t.remove :image_file_size
      t.remove :image_updated_at
    end
  end
  
end
