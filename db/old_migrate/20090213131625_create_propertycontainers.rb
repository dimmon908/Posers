class CreatePropertycontainers < ActiveRecord::Migration
  def self.up
    create_table :propertycontainers do |t|
      t.column :title, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :propertycontainers
  end
end
