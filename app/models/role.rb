class Role < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_length_of :name, :within => 1..40
  
  has_many :forumpermissions
  
  @forumpermissions = {}
  def get_forum_permissions
    @forumpermissions = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
    forumpermissions = Forumpermission.where(:role_id => self.id.to_s)
    forumpermissions.each do |f|
      if f.mode == "forum"
        @forumpermissions['forum'][f.parent_id][f.action] = f.can.to_s
      else
        @forumpermissions['board'][f.action] = f.can.to_s
      end
    end
  end
  def forum_can(action, mode, id)
    if mode == 'forum'
      if @forumpermissions['forum'][id][action] and @forumpermissions['forum'][id][action] == 'true'
        return true
      elsif @forumpermissions['forum'][id][action] and @forumpermissions['forum'][id][action] == 'false'
        return false
      else
        if @forumpermissions['board'][action] and @forumpermissions['board'][action] == 'true'
          return true
        else
          return false
        end
      end
    else
      if @forumpermissions['board'][action] and @forumpermissions['board'][action] == 'true'
        return true
      else
        return false
      end
    end
  end
  
end
