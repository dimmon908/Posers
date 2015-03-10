class CreateRents < ActiveRecord::Migration
  def change
    create_table :rents do |t|
      t.integer :user_id
      t.integer :kunstvoorwerp_id
      t.integer :prijs
      t.boolean :status

      t.timestamps
    end

    add_index :rents, :user_id
    add_index :rents, :kunstvoorwerp_id
  end
end
