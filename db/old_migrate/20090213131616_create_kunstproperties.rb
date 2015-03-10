class CreateKunstproperties < ActiveRecord::Migration
  def self.up
    create_table :kunstproperties do |t|
      t.column :title, :string
      t.column :propertycontainer_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :kunstproperties
  end
end
