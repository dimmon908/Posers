class CreateKprops < ActiveRecord::Migration
  def self.up
    create_table :kprops do |t|
      t.column :kunstproperty_id, :integer
      t.column :kunstvoorwerp_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :kprops
  end
end
