class Kunstimage < ActiveRecord::Base
  belongs_to :kunstvoorwerp
  
  attr_accessor :watermark

  has_attached_file :image,
    :processors => lambda { |instance| instance.watermark ? [:watermark] : [:thumbnail] },
    :storage => :s3,
    :styles => { 
      :square => "188x188#", # (#) para crop e (!)  para resize
      :square_small => "90x90#",
      :info => "465x465>",
      :larger => {
        :geometry => "800x800>",
        :watermark_path => "#{Rails.root}/public/images/watermark.png"
      }
    },
    :s3_credentials => "#{Rails.root}/config/s3.yml", 
    :s3_permissions => 'private',
    :path => ":id_:basename_:style.:extension",
    :bucket => 'xposers_itemimages'
  
  # paperclip event handler
  after_post_process :save_image_dimensions

  # At some point the path for the url changed, and image_file_name field was used
  # instead of filename field to save file names. So image_file_name field is checked
  # to decide which path (file name) to pass to url_for
  def url(name = nil)
    doomsday = Time.mktime(2038, 1, 18).to_i

    if self.image_file_name
      name ||= "original"
      names = image_file_name.split(".")
      extension = names.pop
      file = "#{self.id}_#{names.join(".")}_#{name.to_s}.#{extension}"
      return AWS::S3::S3Object.url_for(file, 'xposers_itemimages', :expires => doomsday)
    end

    return nil if !self.filename || self.filename.empty?
    
    file = "#{self.filename}.#{self.extension}"
    file = "#{self.filename}_#{name.to_s}.#{self.extension}" if name

    return AWS::S3::S3Object.url_for(file, 'xposers_itemimages', :expires => doomsday)
  end

  # Somehow width and height are not saved anymore on database
  # This method gets new images dimensions or return the object if they are
  # already on db
  def dimensions
    if self.width == 0
      geo = Paperclip::Geometry.from_file(self.url)
      self.update_attributes({ width: geo.width, height: geo.height })
      geo
    else
      self
    end
  end

  # this one speaks for itself
  def save_image_dimensions
    geo = Paperclip::Geometry.from_file(image.queued_for_write[:original])
    self.width = geo.width
    self.height = geo.height
  end
end
