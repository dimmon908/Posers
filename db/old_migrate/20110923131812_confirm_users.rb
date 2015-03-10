class ConfirmUsers < ActiveRecord::Migration
  def up
    User.where(:activated => true).each do |user|
      user.confirm!
    end
  end

  def down
  end
end
