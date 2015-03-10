class Forummessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :forumtopic
  has_many :forumreports, :dependent => :destroy

  validates_length_of :raw, :minimum => 3, :too_short => "Je bericht is te kort"
end
