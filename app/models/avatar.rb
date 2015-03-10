class Avatar < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :image,
    :storage => :s3,
    :styles => { :thumb => "80x80!" },
    :s3_credentials => "#{Rails.root}/config/s3.yml", 
    :s3_permissions => 'private',
    :path => ":id_:basename.:extension",
    :bucket => 'xposers_avatars'
  
  # At some point the path for the url changed, and image_file_name field was used
  # instead of filename field to save file names. So filename field nil is checked
  # to decide which path (file name) to pass to url_for
  def url
    doomsday = Time.mktime(2038, 1, 18).to_i
    if self.filename.nil?
      AWS::S3::S3Object.url_for("#{id}_#{image_file_name}", "xposers_avatars", :expires => doomsday)
    else
      AWS::S3::S3Object.url_for(image_file_name, "xposers_avatars", :expires => doomsday)
    end
  end
  
end
