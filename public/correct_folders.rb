Dir.open(Dir.pwd).each do |filename|
	puts "\n-> Next item is #{filename}"
	if File.directory? filename
		if filename == 'avatars'
		  puts "   -> #{File.expand_path(filename)}"
			puts "   AVATARS directory will be parsed - getting subfolders"
			subfolders = Dir.entries("#{File.expand_path(filename)}/0000")
			subfolders.each do |current_folder|
				if File.directory? "#{File.expand_path(filename)}/0000/#{current_folder}"
					subfiles = Dir.entries("#{File.expand_path(filename)}/0000/#{current_folder}")
					subfiles.each do |current_file|
						puts "   |-- #{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}"
						unless File.directory? "#{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}"
							begin
								File.copy_stream("#{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}", "#{Dir.pwd}/avatars_parsed/0000_#{current_folder}_#{current_file}")
								puts "   | -> Copied #{File.expand_path(filename)}/0000/#{current_folder}/#{current_file} >> #{Dir.pwd}/avatars_parsed/0000_#{current_folder}_#{current_file}"
							rescue 
								puts "ERROR "
							end
						end
					end
				end
			end
		elsif filename == 'closeups'
		  puts "   -> #{File.expand_path(filename)}"
			puts "   CLOSEUPS directory will be parsed - getting subfolders"
			subfolders = Dir.entries("#{File.expand_path(filename)}/0000")
			subfolders.each do |current_folder|
				if File.directory? "#{File.expand_path(filename)}/0000/#{current_folder}"
					subfiles = Dir.entries("#{File.expand_path(filename)}/0000/#{current_folder}")
					subfiles.each do |current_file|
						puts "   |-- #{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}"
						unless File.directory? "#{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}"
							begin
								File.copy_stream("#{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}", "#{Dir.pwd}/closeups_parsed/0000_#{current_folder}_#{current_file}")
								puts "   | -> Copied #{File.expand_path(filename)}/0000/#{current_folder}/#{current_file} >> #{Dir.pwd}/closeups_parsed/0000_#{current_folder}_#{current_file}"
							rescue 
								puts "ERROR "
							end
						end
					end
				end
			end
		elsif filename == 'interieurs'
		  puts "   -> #{File.expand_path(filename)}"
			puts "   interieurs directory will be parsed - getting subfolders"
			subfolders = Dir.entries("#{File.expand_path(filename)}/0000")
			subfolders.each do |current_folder|
				if File.directory? "#{File.expand_path(filename)}/0000/#{current_folder}"
					subfiles = Dir.entries("#{File.expand_path(filename)}/0000/#{current_folder}")
					subfiles.each do |current_file|
						puts "   |-- #{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}"
						unless File.directory? "#{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}"
							begin
								File.copy_stream("#{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}", "#{Dir.pwd}/interieurs_parsed/0000_#{current_folder}_#{current_file}")
								puts "   | -> Copied #{File.expand_path(filename)}/0000/#{current_folder}/#{current_file} >> #{Dir.pwd}/interieurs_parsed/0000_#{current_folder}_#{current_file}"
							rescue 
								puts "ERROR "
							end
						end
					end
				end
			end
		elsif filename == 'webimages'
		  puts "   -> #{File.expand_path(filename)}"
			puts "   webimages directory will be parsed - getting subfolders"
			subfolders = Dir.entries("#{File.expand_path(filename)}/0000")
			subfolders.each do |current_folder|
				if File.directory? "#{File.expand_path(filename)}/0000/#{current_folder}"
					subfiles = Dir.entries("#{File.expand_path(filename)}/0000/#{current_folder}")
					subfiles.each do |current_file|
						puts "   |-- #{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}"
						unless File.directory? "#{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}"
							begin
								File.copy_stream("#{File.expand_path(filename)}/0000/#{current_folder}/#{current_file}", "#{Dir.pwd}/webimages_parsed/0000_#{current_folder}_#{current_file}")
								puts "   | -> Copied #{File.expand_path(filename)}/0000/#{current_folder}/#{current_file} >> #{Dir.pwd}/webimages_parsed/0000_#{current_folder}_#{current_file}"
							rescue 
								puts "ERROR "
							end
						end
					end
				end
			end
		end
		
		
	end
end
