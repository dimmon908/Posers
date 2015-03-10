class Forumreport < ActiveRecord::Base
  belongs_to :forummessage
  belongs_to :user
end
