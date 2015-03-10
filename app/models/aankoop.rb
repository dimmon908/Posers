class Aankoop < ActiveRecord::Base
  belongs_to :user
  belongs_to :kunstvoorwerp
  
  # Register order and change artwork status
  #
  def self.confirm user, kunstvoorwerp
    aankoop = user.aankoops.new
    aankoop.kunstvoorwerp_id = kunstvoorwerp.id
    aankoop.prijs = kunstvoorwerp.prijs
    
    aankoop.status = 'nieuw'
    if aankoop.save
      kunstvoorwerp.update_attribute('status', 1)
      aankoop
    else
      false
    end
  end  
end
