class CreatePrefabmails < ActiveRecord::Migration
  def self.up
    create_table :prefabmails do |t|
      t.column :content, :text
      t.column :totype, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :prefabmails
  end
end
