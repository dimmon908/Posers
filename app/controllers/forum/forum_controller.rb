class Forum::ForumController < ApplicationController
  layout 'forum'
  before_filter :forum_permissions

  def index
    @title = 'Forum'
    @parent_categories = Forumparentcategory.includes(:forumcategories, :user)
                                            .order('forumparentcategories.id ASC')

    @forums = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }

    @parent_categories.each do |parent|
      @forums[parent.id]['parent'] = parent

      parent.forumcategories.each do |category|
        if @me.role.forum_can('view', 'forum', category.id)
          @forums[parent.id]['categories'][category.id] = category
        end
      end
    end
  end

  def subforum
    if !params[:id] or !is_a_number?(params[:id])
      redirect_to root_url, notice: "De door u gezochte pagina bestaat niet." and return
    end

    @forum = Forumcategory.find(params[:id])
    @title = @forum.title

    if !@me.role.forum_can('view', 'forum', @forum.id)
      hit_error(403) and return
    end

    @breadcrumbs = [:s1 => {:title => @forum.title}]
    
    @topics = Forumtopic.paginate(:page => params[:page],
                                  :select => "forumtopics.*, users.nickname, u2.nickname AS last_reply_user_nickname",
                                  :joins => "inner join users on users.id = forumtopics.user_id left join users u2 on u2.id = forumtopics.lastreply_user_id",
                                  :conditions => " forumcategory_id  = " + sanitize_int(params[:id]),
                                  :per_page => 50,
                                  :order => 'forumtopics.lastreply_user_datetime DESC, forumtopics.created_at DESC')
  end
end
