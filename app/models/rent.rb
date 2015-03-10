class Rent < ActiveRecord::Base
  belongs_to :user
  belongs_to :kunstvoorwerp

  validates :user_id, :kunstvoorwerp_id, :prijs, presence: true

  before_create :change_artwork_status

  def confirm(user)
    self.status = 'niew'
    self.user_id = user.id
    self.prijs = self.kunstvoorwerp.prijs
    self.save
  end 

  private
    
    def change_artwork_status
      self.kunstvoorwerp.status = 1
      self.kunstvoorwerp.save
    end
end
