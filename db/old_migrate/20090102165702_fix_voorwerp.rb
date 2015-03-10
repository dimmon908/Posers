class FixVoorwerp < ActiveRecord::Migration
  def self.up
    add_column :kunstvoorwerps, :stijl_id, :integer
    add_column :kunstvoorwerps, :materiaal_id, :integer
    add_column :kunstvoorwerps, :techniek_id, :integer
    add_column :kunstvoorwerps, :kleur_id, :integer

  end

  def self.down
  end
end
