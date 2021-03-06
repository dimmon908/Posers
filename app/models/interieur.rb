class Interieur < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :image,
    :storage => :s3,
    :styles => { :normal => "800x800>" },
    :s3_credentials => "#{Rails.root}/config/s3.yml", 
    :s3_permissions => 'private',
    :path => ":id_:basename_:style.:extension",
    :bucket => 'xposers_interieurs'

  # At some point the path for the url changed, and image_file_name field was used
  # instead of filename field to save file names. So filename field is checked
  # to decide which path (file name) to pass to url_for
  def url
    doomsday = Time.mktime(2038, 1, 18).to_i

    unless self.filename.nil?
      AWS::S3::S3Object.url_for(image_file_name, 'xposers_interieurs', :expires => doomsday)
    else
      names = image_file_name.split(".")
      extension = names.pop
      file = "#{self.id}_#{names.join(".")}_normal.#{extension}"
      AWS::S3::S3Object.url_for(file, 'xposers_interieurs', :expires => doomsday)
    end
  end

  # Somehow width and height are not saved anymore on database
  # This method gets new images dimensions or return the object if they are
  # already on db
  #
  def dimensions
    unless self.width
      geo = Paperclip::Geometry.from_file(self.url)
      self.update_attributes({ width: geo.width, height: geo.height })
      geo
    else
      self
    end
  end

end
