class RemoveUserNotNull < ActiveRecord::Migration
  def up
    change_column_default(:users, :tussenvoegsel, nil)
    change_column_default(:users, :achternaam_kort, nil)
  end

  def down
  end
end
