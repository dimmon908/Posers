class CreateIntmails < ActiveRecord::Migration
  def self.up
    create_table :intmails do |t|
      t.column :inttitle, :string
      t.column :title, :string
      t.column :message, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :intmails
  end
end
