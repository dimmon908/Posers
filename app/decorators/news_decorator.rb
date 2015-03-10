class NewsDecorator
  def initialize(news)
    @news = news
  end
  
  def author_name
    @news.user.voornaam ? "#{@news.user.voornaam} #{@news.user.achternaam}" : @news.user.nickname
  end
  
  def created_at
    @news.created_at.strftime('%Y-%m-%d')
  end
  
  def content
    @news.content
  end
  
  def to_s
    "<strong>#{content}</strong> Door: #{author_name} in #{created_at}"
  end
  
end