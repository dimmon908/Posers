class AddForRentToKunstvoorwerp < ActiveRecord::Migration
  def change
    add_column :kunstvoorwerps, :for_rent, :boolean
  end
end
