class Abusereport < ActiveRecord::Base
  belongs_to :user
  belongs_to :kunstvoorwerp
  belongs_to :reply
end
