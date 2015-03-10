class ChangeStatusFromRent < ActiveRecord::Migration
  def up
    change_column :rents, :status, :string
  end

  def down
    change_column :rents, :status, :boolean
  end
end
