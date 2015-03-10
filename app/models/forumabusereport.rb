class Forumabusereport < ActiveRecord::Base
  belongs_to :user
  belongs_to :forummessage
end
