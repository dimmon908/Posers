class Propertycontainer < ActiveRecord::Base
  has_many :kunstproperties, :dependent => :destroy
  belongs_to :type
end
