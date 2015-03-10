desc "Compare some db entries"
task :compare do
  RAILS_ENV='development'
  Rake::Task[:environment].invoke
  models = Dir["#{Rails.root}/app/models/*.rb"]
  models.each do |model_file|
    base_file = File.basename(model_file).gsub(/.rb/, '')
    model_class = base_file.camelize.constantize
    begin
      actual = model_class.send(:conn, :development).send(:order, "id desc")
      another = model_class.send(:conn, :devmysql).send(:order, "id desc")
      if actual.size != another.size
        puts "Diff between entries in #{model_class}: pg: #{actual.size} -> mysql: #{another.size}"
      end
      another.each do |old|
        found = false
        actual.each do |obj|
          if old == obj
            found = true
            break
          end
        end
        puts "#{model_class}: #{old.inspect} not found" unless found
      end
    rescue
      puts "Fail to parse #{model_class}"
    end
  end
end

desc "Compare some db entries in {Kunstimage}"
task :compare_image do
  RAILS_ENV='development'
  Rake::Task[:environment].invoke
  images = Kunstimage.all
  msql_images = Kunstimage.conn(:devmysql).all
  msql_images.each do |image|
    found = false
    images.each do |mimage|
      if image.filename == mimage.filename
        found = true
        break
      end
    end
    unless found
      puts "Image not found #{image.id} - #{image.kunstvoorwerp_id} - #{image.filename}"
      Kunstimage.conn(:development).create!(kunstvoorwerp_id: image.kunstvoorwerp_id, 
        content_type: image.content_type, filename: image.filename, extension: image.extension, 
        width: image.width, height: image.height)
    end
  end
end