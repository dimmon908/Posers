module ApplicationHelper
  
  def error_messages_for(*params)
    options = params.extract_options!.symbolize_keys

    if object = options.delete(:object)
      objects = [object].flatten
    else
     objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    end

    count  = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'errorExplanation'
        end
      end
      options[:object_name] ||= params.first

      I18n.with_options :locale => options[:locale], :scope => [:activerecord, :errors, :template] do |locale|
        header_message = if options.include?(:header_message)
          options[:header_message]
        else
          object_name = options[:object_name].to_s.gsub('_', ' ')
          object_name = I18n.t(object_name, :default => object_name, :scope => [:activerecord, :models], :count => 1)
          locale.t :header, :count => count, :model => object_name
        end
        message = options.include?(:message) ? options[:message] : locale.t(:body)
        #error_messages = objects.sum {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }.join
        error_messages = objects.map {|object| object.errors.collect{ |column,error| content_tag( :li, error ) } }

        contents = ''
        contents << content_tag(options[:header_tag] || :h3, header_message) unless header_message.blank?
        contents << content_tag(:p, message) unless message.blank?
        contents << content_tag(:ul, error_messages)
        content_tag(:div, contents, html)
      end
    else
      ''
    end
  end

  def show_page(title)
    page = Page.find_by_title(title)
    if page.blank?
      return ''
    else
      return page.content.html_safe
    end
  end

  def forump (id, messages)
    ret = '[  '
    pg = messages / 20.0
  	pg = pg.ceil
  	if pg > 6
	    ret = ret + '<a href="' + viewtopicpage_url(:id => id, :page => 1) + '">1</a> '
	    ret = ret + '<a href="' + viewtopicpage_url(:id => id, :page => 2) + '">2</a> .. ' 
	    ret = ret + '<a href="' + viewtopicpage_url(:id => id, :page => pg - 1) + '">' + (pg-1).to_s + '</a> ' 
	    ret = ret + '<a href="' + viewtopicpage_url(:id => id, :page => pg) + '">' + pg.to_s + '</a> '    
    else
  	  i = 0
  	  while i < pg do
  	    ret = ret + '<a href="' + viewtopicpage_url(:id => id, :page => i+1) + '">' + (i + 1).to_s + '</a> ' 
  	    i += 1
  	  end
  	end  
  	ret = ret + "]"
  	return ret
  end
  def webimage_url(id)
    Webimage.find(id).url
  end

  def complete_username(user)
    "#{user.voornaam} #{user.tussenvoegsel} #{user.achternaam}" 
  end
  alias :user_fullname :complete_username
end
