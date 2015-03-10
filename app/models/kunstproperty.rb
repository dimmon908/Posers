class Kunstproperty < ActiveRecord::Base
  belongs_to :propertycontainer
  belongs_to :kunstvoorwerp
  
  has_many :kprops, :dependent => :destroy
end
