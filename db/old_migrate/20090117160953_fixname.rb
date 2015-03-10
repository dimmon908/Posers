class Fixname < ActiveRecord::Migration
  def self.up
    add_column :users, :voornaam, :string
    add_column :users, :achternaam, :string
  end

  def self.down
    remove_column :users, :voornaam
    remove_column :users, :achternaam
  end
end
