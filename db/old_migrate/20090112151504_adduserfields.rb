class Adduserfields < ActiveRecord::Migration
  def self.up
    add_column :users, :profile_geboorteplaats, :string
    add_column :users, :profile_geboortedatum, :string
    add_column :users, :profile_cv, :text
    add_column :users, :profile_opleidingen, :text
    add_column :users, :profile_exposities, :text
    add_column :users, :profile_prijzen, :text
    add_column :users, :prive_adres, :string
    add_column :users, :prive_woonplaats, :string
    add_column :users, :prive_postcode, :string
    add_column :users, :prive_land, :string
  end

  def self.down
  end
end
