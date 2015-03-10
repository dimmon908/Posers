class Type < ActiveRecord::Base
  has_many :kunstvoorwerps
  belongs_to :kunstvoorwerp
  has_many :stijls
  has_many :technieks
  has_many :kleurs
  has_many :materiaals
  
  has_many :propertycontainers, :dependent => :destroy
  
end
