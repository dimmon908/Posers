class Forumparentcategory < ActiveRecord::Base
  has_many :forumcategories, :dependent => :destroy
  belongs_to :user
end
