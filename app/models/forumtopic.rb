class Forumtopic < ActiveRecord::Base
  belongs_to :forumcategory
  belongs_to :user

  # has_one :forummessage, :conditions => ['forummessages.topicstart = ?', true]
  has_many :forummessages, :dependent => :destroy

  validates_presence_of :title
end
