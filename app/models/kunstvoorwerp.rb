class Kunstvoorwerp < ActiveRecord::Base

  VERZENDMETHODE = ['Gewone post koper', 'Pakketpost verkoper', 'Xposers bezorging', 'Neem contact met verkoper op']

  belongs_to :type
  belongs_to :user

  has_one :kunstimage, :dependent => :destroy
  has_one :closeup, :dependent => :destroy
  
  has_many :appreciations, :dependent => :destroy
  has_many :abusereports, :dependent => :destroy
  has_many :favourites, :dependent => :destroy
  has_many :replies, :dependent => :destroy
  has_many :kprops
  has_many :kunstproperties, :through => :kprops
  has_many :rents
  
  
  validates_length_of :title, :within => 2..90, :too_long => "De titel is te lang", :too_short =>"De titel is te kort."
  validates_length_of :description, :within => 2..1500, :too_long => "De omschrijving is te lang", :too_short =>"De omschrijving is te kort."
  
  validates_numericality_of :prijs, greater_than: 0, :message => "Prijs is geen getal"
  validates_numericality_of :height, :message => "Hoogte is geen getal"
  validates_numericality_of :width, :message => "Breedte is geen getal"
  validates_numericality_of :type_id, :message => "Geen type gekozen"
  
  attr_protected :user_id
  
  scope :actives, where(:active => true)

  # Returns strings describing shipping method
  #
  def shipping_method
    VERZENDMETHODE[self.verzendmethode]
  end

  # Get 20 random ids with active artworks
  # Returns collection with all info from choses artworks 
  #
  def self.random
    ids = Kunstvoorwerp.actives.select(:id).sort_by { rand }.slice(0, 20)
    collection = Kunstvoorwerp.includes(:kunstimage, :user).where(id: ids)
  end
end
