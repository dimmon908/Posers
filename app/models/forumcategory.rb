class Forumcategory < ActiveRecord::Base
  belongs_to :forumparentcategory
  belongs_to :user
  has_many :forumtopics, :dependent => :destroy
  has_many :forummessages, :through => :forumtopics
end
