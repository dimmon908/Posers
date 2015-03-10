class Forum::ActivetopicsController < ApplicationController
  layout 'forum'
  before_filter :forum_permissions

  def index
    @title = 'Actieve topics'
    okfora = []
    @topics = []
    
    @pcat = Forumparentcategory.find(:all, :select => 'forumparentcategories.id AS cat_id, forumparentcategories.title AS cat_title, forumcategories.*, users.nickname AS last_reply_user_nickname', :order => 'forumparentcategories.id ASC', :joins => 'INNER JOIN forumcategories ON forumcategories.forumparentcategory_id = forumparentcategories.id LEFT JOIN users ON users.id = forumcategories.lastreply_user_id')
    @forums = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
    @pcat.each do |p|
      if @me.role.forum_can('view', 'forum', p.id)
        okfora.push p.id
      end
    end
    #pagination thing
    if params[:page]
      page = params[:page]
    else
      page = nil
    end
    @topics = Forumtopic.paginate(:page => page, :select => "forumtopics.*, users.nickname", :joins => "inner join users on users.id = forumtopics.user_id", :conditions => " forumcategory_id IN(" + okfora.join(',') + ")", :per_page => 50, :order => 'forumtopics.lastreply_user_datetime DESC, forumtopics.created_at DESC')
  end

  def mytopics
    @title = 'Mijn topics'
    okfora = []
    @topics = []
    
    @pcat = Forumparentcategory.find(:all, :select => 'forumparentcategories.id AS cat_id, forumparentcategories.title AS cat_title, forumcategories.*, users.nickname AS last_reply_user_nickname', :order => 'forumparentcategories.id ASC', :joins => 'INNER JOIN forumcategories ON forumcategories.forumparentcategory_id = forumparentcategories.id LEFT JOIN users ON users.id = forumcategories.lastreply_user_id')
    @forums = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
    @pcat.each do |p|
      if @me.role.forum_can('view', 'forum', p.id)
        okfora.push p.id
      end
    end
    #pagination thing
    if params[:page]
      page = params[:page]
    else
      page = nil
    end
    @topics = Forumtopic.paginate(:page => page, :select => "forumtopics.*, users.nickname", :joins => "inner join users on users.id = forumtopics.user_id", :conditions => " forumcategory_id IN(" + okfora.join(',') + ") AND forumtopics.user_id = " + @me.id.to_s, :per_page => 50, :order => 'forumtopics.lastreply_user_datetime DESC, forumtopics.created_at DESC')
  end

  def mymessages
    @title = 'Mijn berichten'
    okfora = []
    @topics = []
    
    @pcat = Forumparentcategory.find(:all, 
      :select => 'forumparentcategories.id AS cat_id, forumparentcategories.title AS cat_title, forumcategories.*, users.nickname AS last_reply_user_nickname', 
      :order => 'forumparentcategories.id ASC', 
      :joins => 'INNER JOIN forumcategories ON forumcategories.forumparentcategory_id = forumparentcategories.id LEFT JOIN users ON users.id = forumcategories.lastreply_user_id')
    @forums = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
    @pcat.each do |p|
      if @me.role.forum_can('view', 'forum', p.id)
        okfora.push p.id
      end
    end
    #pagination thing
    if params[:page]
      page = params[:page]
    else
      page = nil
    end
    @topics = Forumtopic.paginate(:page => page, 
      :select => "forumtopics.*, users.nickname", 
      :joins => "inner join users on users.id = forumtopics.user_id inner join forummessages on forummessages.forumtopic_id = forumtopics.id", 
      :conditions => " forumcategory_id IN(" + okfora.join(',') + ") AND (forummessages.user_id = #{@me.id} OR forumtopics.user_id = #{@me.id})" , 
      :per_page => 50, 
      :group => 'users.id, forumtopics.id', 
      :order => 'forumtopics.lastreply_user_datetime DESC, forumtopics.created_at DESC')
  end
end
