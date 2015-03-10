class Webimage < ActiveRecord::Base
  has_attached_file :image,
    :storage => :s3,
    :styles => { :normal => "610x610>" },
    :s3_credentials => "#{Rails.root}/config/s3.yml", 
    :s3_permissions => 'private',
    :path => ":id_:basename_:style.:extension",
    :bucket => 'xposers_webimages'
  
  # At some point the path for the url changed, and image_file_name field was used
  # instead of filename field to save file names. So filename field nil is checked
  # to decide which path (file name) to pass to url_for
  def url
    doomsday = Time.mktime(2038, 1, 18).to_i

    unless self.filename.nil?
      @s3_image ||= AWS::S3::S3Object.url_for(image_file_name, 'xposers_webimages', :expires => doomsday)
    else
      names = image_file_name.split(".")
      extension = names.pop
      file = "#{self.id}_#{names.join(".")}_normal.#{extension}"
      @s3_image ||= AWS::S3::S3Object.url_for(file, 'xposers_webimages', :expires => doomsday)
    end
  end
  
end
