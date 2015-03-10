class SiteController < ApplicationController
  before_filter :forum_permissions
  layout 'frontpage'

  def index

    @kvs = Kunstvoorwerp.actives.joins(:kunstimage, :user).limit(4).order('kunstvoorwerps.created_at DESC')

    if current_user
      @favorieten = Favourite.find(:all, :conditions => 'user_id = ' + @me.id.to_s, :limit => 10, :include => [:kunstvoorwerp, :user])
      
      okfora = []
      @topics = []

      @pcat = Forumparentcategory.find(:all,
                                       :select => 'forumparentcategories.id AS cat_id, forumparentcategories.title AS cat_title, forumcategories.*, users.nickname AS last_reply_user_nickname',
                                       :order => 'forumparentcategories.id ASC',
                                       :joins => 'INNER JOIN forumcategories ON forumcategories.forumparentcategory_id = forumparentcategories.id LEFT JOIN users ON users.id = forumcategories.lastreply_user_id')
      @forums = Hash.new{|h,k| h[k] = Hash.new(&h.default_proc) }

      @pcat.each do |p|
        if @me.role.forum_can('view', 'forum', p.id)
          okfora.push p.id
        end
      end

      if !okfora.blank?
        @topics = Forumtopic.find(:all,
                                  :select => "forumtopics.*, users.nickname", :joins => "inner join users on users.id = forumtopics.user_id", :conditions => " forumcategory_id IN(" + okfora.join(',') + ")",
                                  :order => 'forumtopics.lastreply_user_datetime DESC, forumtopics.created_at DESC', :limit => 10)
      end

      if @me.can('admin')
        @sitemeldingen = Abusereport.joins(:user).joins(:kunstvoorwerp => :user, :reply => :user).limit(30)
      end
    end

    @art = Kunstvoorwerp.count
    @members = User.count
    @messages = Forummessage.count

    @last_news = News.last_news

    # Get content for page under 4 artworks
    @central_page = Page.find_by_title('welkom').content

    # pics for right column bottom
    artwork_count = Kunstvoorwerp.where(active: true).count
    @rand_picture_01 = Kunstvoorwerp.includes(:user).where(active: true).first(offset: rand(artwork_count))
    @rand_picture_02 = Kunstvoorwerp.includes(:user).where(active: true).first(offset: rand(artwork_count))

    # Get content for right column
    @right_column = Page.find(34).content
  end

  def contact
  end

  def overxposers
  end
end
