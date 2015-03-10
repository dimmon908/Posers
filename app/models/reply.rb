class Reply < ActiveRecord::Base
  validates_length_of :raw, :within => 3..900, :too_long => "De reactie is te lang", :too_short =>"De reactie is te kort."
  
  belongs_to :kunstvoorwerp
  belongs_to :user
end
