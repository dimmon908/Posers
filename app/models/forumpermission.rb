class Forumpermission < ActiveRecord::Base
  belongs_to :role
  def getmypermissions
    permissions = self.find(:all, :conditions => 'user_id = '+ @me.id)
    return permissions
  end
end
