class Addstijlding < ActiveRecord::Migration
  def self.up
    add_column :propertycontainers, :type_id, :integer
  end

  def self.down
  end
end
