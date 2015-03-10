class AddPaperclipToKunstimage < ActiveRecord::Migration
  def change
    change_table :kunstimages do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.datetime :image_updated_at
    end
  end
end