class Forum::TopicController < ApplicationController
  layout 'forum'
  before_filter :forum_permissions

  def index
    if !params[:id] or !is_a_number?(params[:id]) or params[:id] == ''
      flash[:notice] = "De door u gezochte pagina bestaat niet."
      redirect_to root_url
      return nil
    end
    @topic = Forumtopic.find_by_id(params[:id], :include => {:user => :avatar})
    if @topic.blank?
      flash[:notice] = "De door u gezochte pagina bestaat niet."
      redirect_to root_url
      return nil
    end
    @forum = Forumcategory.find_by_id(@topic.forumcategory_id)
    if !@me.role.forum_can('view', 'forum', @topic.forumcategory_id)
      hit_error(403)
      return nil
    end
    if params[:page]
      page = params[:page]
    else
      page = nil
    end
    
    # pagination thing
    if @me.role.forum_can('mod', 'forum', @forum.id)
      @messages = Forummessage.paginate(
        :page => page,
        :include => {:user => :avatar},
        :conditions => { forumtopic_id: params[:id] },
        :order => 'created_at ASC', :per_page => 20
      )
    else
      @messages = Forummessage.paginate(
        :page => page,
        :include => {:user => :avatar},
        :conditions => { hidden: false , forumtopic_id: params[:id] },
        :order => 'created_at ASC', :per_page => 20
      )
    end
    Rails.logger.info @messages.size
    @title = @topic.title
  end

  def new
    @message = []
    if !params[:id] or !is_a_number?(params[:id]) or params[:id] == ''
      flash[:notice] = "De door u gezochte pagina bestaat niet."
      redirect_to root_url
    end
    @forum = Forumcategory.find_by_id(params[:id])
    if @forum.blank?
      flash[:notice] = "De door u gezochte pagina bestaat niet."
      redirect_to root_url
    end

    if !@me.role.forum_can('view', 'forum', @forum.id) or !@me.role.forum_can('newtopic', 'forum', @forum.id)
      hit_error(403)
    end
    # all ok, can post now
    if request.post?
      if params[:topic][:postmode] == 'new'
        if params[:topic][:mode] and params[:topic][:ttype] and @me.role.forum_can('mod', 'forum', @forum.id)
          # moderator mode!
          if params[:topic][:ttype] == 'normal' or params[:topic][:ttype] == 'announcement' or params[:topic][:ttype] == 'sticky'
            ttype = params[:topic][:ttype]
          else
            ttype = 'normal'
          end
          if params[:topic][:mode] and (params[:topic][:mode] == '1' or params[:topic][:mode] == '0')
            locked = params[:topic][:mode]
          else
            locked = 0
          end
          @topic = @forum.forumtopics.new({:title => params[:topic][:title], :locked => locked, :ttype => ttype, :user_id => @me.id})
        else
          # human being mode!
          @topic = Forumtopic.new(:title => params[:topic][:title], :locked => params[:topic][:mode], :ttype => 'normal', :user_id => @me.id)
        end
        if params[:topic][:message].length < 3
          @topic.errors.add_to_base("Message to short")
        end
        @topic.forumcategory_id = @forum.id
        @topic.save
        @forum.topics_count = @forum.topics_count + 1
        @forum.messages_count = @forum.messages_count + 1
        @forum.lastreply_user_id = @me.id
        @forum.lastreply_at = Time.now
        @forum.save
        @message[0] = sanitize_text(params[:topic][:message])
        @message[1] = params[:topic][:message]
        @newmessage = Forummessage.new(:forumtopic_id => @topic.id, :raw => @message[0], :processed => @message[1], :user_id => @me.id, :topicstart => true)
        @newmessage.save
        @topic.update_attributes({:message_id => @newmessage.id, :lastreply_user_datetime => Time.now, :message_count => @topic.message_count.succ, :lastreply_user_id => @me.id})
        redirect_to viewtopic_url(:id => @topic.id)
      else
        @message[0] = sanitize_text(params[:topic][:message])
        @message[1] = params[:topic][:message]
        @topic = Forumtopic.new({:title => params[:topic][:title], :locked => params[:topic][:mode], :forumcategory_id => @forum.id, :ttype => 'normal'})
        render :action => 'preview'
      end
    end
  end

  def delete
    @topic = Forumtopic.find_by_id(params[:id])
    @forum = @topic.forumcategory
    @title = @topic.title
    if @topic.blank?
      flash[:notice] = "De door u gezochte pagina bestaat niet."
      redirect_to root_url
    end
    if !@me.role.forum_can('mod', 'forum', @forum.id)
      return hit_error(403)
    end
    if request.post?
      @forum.messages_count = @forum.messages_count - @topic.message_count
      @forum.topics_count = @forum.topics_count - 1       
      fid = @topic.forumcategory_id
      @topic.forummessages.delete
      @topic.delete
      
      @forum.save
      redirect_to viewforum_url(:id => fid)
    end
  end

  def edit
    @message = []
    if !params[:id] or !is_a_number?(params[:id]) or params[:id] == ''
      flash[:notice] = "De door u gezochte pagina bestaat niet."
       redirect_to root_url
    end
    @topic = Forumtopic.find_by_id(params[:id])
    @forum = @topic.forumcategory
    @title = @topic.title
    if @topic.blank?
      flash[:notice] = "De door u gezochte pagina bestaat niet."
      redirect_to root_url
    end
    if @topic.user.id != @me.id and !@me.role.forum_can('mod', 'forum', @forum.id)
      return hit_error(403)
    end
    if request.post?
      if @me.role.forum_can('mod', 'forum', @forum.id)
        @topic.title = params[:topic][:title]
        if params[:topic][:mode] and (params[:topic][:mode] == '1' or params[:topic][:mode] == '0')
          locked = params[:topic][:mode]
        else
          locked = 0
        end
        if params[:topic][:ttype] == 'normal' or params[:topic][:ttype] == 'announcement' or params[:topic][:ttype] == 'sticky'
          ttype = params[:topic][:ttype]
        else
          ttype = 'normal'
        end
        @topic.locked = locked
        @topic.ttype = ttype
      end
      @topic.forummessage.raw = sanitize_text(params[:topic][:message])
      @topic.forummessage.processed = params[:topic][:message]
      @topic.save
      @topic.forummessage.save
      if @topic.valid?
        redirect_to viewtopic_url(:id => @topic.id)
      end
    end
    @forum = @topic.forumcategory
    @message[0] = @topic.forummessage.raw
  end

  def newmessage
    @msg = []
    @msg[0] = ''
    if !params[:id] or !is_a_number?(params[:id]) or params[:id] == ''
      flash[:notice] = "De door u gezochte pagina bestaat niet."
      redirect_to root_url
    end
    @topic = Forumtopic.find_by_id(params[:id])
    if @topic.blank?
      flash[:notice] = "De door u gezochte pagina bestaat niet."
      redirect_to root_url
    end
    if !@logged_in
      return hit_error(403)
    end
    if !@me.role.forum_can('view', 'forum', @topic.forumcategory_id) or !@me.role.forum_can('reply', 'forum', @topic.forumcategory_id)
      return hit_error(403)
    end
    if @topic.locked and !@me.role.forum_can('mod', 'forum', @topic.forumcategory_id)
      return hit_error(403)
    end
    # all ok, can post now
    @forum = Forumcategory.find_by_id(@topic.forumcategory_id)

    if request.post?
      if params[:message][:message] and params[:id]
        @msg[0] = sanitize_text(params[:message][:message])
        @msg[1] = params[:message][:message]
        @message = @topic.forummessages.new(:raw => @msg[0], :processed => @msg[1], :user_id => @me.id)
        @forum.messages_count = @forum.messages_count + 1
        @forum.lastreply_user_id = @me.id
        @forum.lastreply_at = Time.now
        @forum.save
        if @message.valid?
          @message.save
          @topic.update_attributes({:lastreply_user_datetime => Time.now, :message_count => @topic.message_count.succ, :lastreply_user_id => @me.id})
          page = @topic.message_count / 20.0
          page = page.ceil
          redirect_to viewtopicpage_url(:id => @topic.id, :page => page) + "#p" + @message.id.to_s
        end
      end
    else
      @message = @topic.forummessages.new(:raw => @msg[0], :processed => @msg[1], :user_id => @me.id)
      if params[:cite]
        @citation = @topic.forummessages.find_by_id(params[:cite])
        @msg[0] = "[quote=" + @citation.user.nickname + ", " + @citation.created_at.strftime('%Y-%m-%d %H:%M') + "]" + @citation.raw.gsub(/\[quote.*\]*.\[\/quote\]/, "[b][..][/b]\n") + "[/quote]\n"
      end
    end
  end

  def reportmessage
    if !@logged_in
      return hit_error(403)
    end
    
    @message = Forummessage.find(params[:id])
    @topic = @message.forumtopic
    
    if @topic.locked and !@me.role.forum_can('mod', 'forum', @topic.forumcategory_id)
      return hit_error(403)
    end
    
    @forum = @topic.forumcategory
    @msg = []
    @msg[0] = ''
    
    if request.post?
      # new report
      @report = Forumreport.new(params[:report])
      @report.user_id = @me.id
      @report.forummessage_id = params[:id]
      @msg[0] = params[:report][:message]

      @message.update_attribute('reportcount', (@message.reportcount + 1))

      # check if too many reports
      uniquereports = Forumreport.where(forummessage_id: @message.id).group('user_id').count
      if (uniquereports != 0 and uniquereports == @forum.maxwarnings)
        @message.update_attribute('hidden', true)
      end
     
      if @report.save
        flash[:notice] = 'Bericht gerapporteerd'
        redirect_to viewtopic_url(:id => @topic.id)
      end
    end
    
    @title = @topic.title
  end

  def editmessage
    @message = Forummessage.find(params[:id])
    @topic = @message.forumtopic
    @forum = @topic.forumcategory
    if !@logged_in
      return hit_error(403)
    end
    if @topic.locked and !@me.role.forum_can('mod', 'forum', @topic.forumcategory_id)
      return hit_error(403)
    end
    if @message.user_id != @me.id and !@me.role.forum_can('mod', 'forum', @topic.forumcategory_id)
      return hit_error(403)
    end
    if request.post?
      @message.raw = sanitize_text(params[:message][:message])
      @message.processed = params[:message][:message]
      @message.save
      if @me.role.forum_can('mod', 'forum', @topic.forumcategory_id)
        @message.update_attribute('hidden', params[:message][:hidden])
      end
      
      if @message.valid?
        redirect_to viewtopic_url(:id => @message.forumtopic_id)
      end
    end

    @msg = []
    @msg[0] = @message.raw
  end

  def movetopic
    @topic = Forumtopic.find_by_id(params[:id])
    @forum = @topic.forumcategory
    @forums = Forumcategory.find(:all)
    @title = @topic.title
    if @topic.blank?
      flash[:notice] = "De door u gezochte pagina bestaat niet."
       redirect_to root_url
    end
    if !@me.role.forum_can('mod', 'forum', @forum.id)
      return hit_error(403)
    end
    if request.post?
      @forum.messages_count = @forum.messages_count - @topic.message_count
      @forum.topics_count = @forum.topics_count - 1       
      @forum.save
      @topic.update_attribute(:forumcategory_id, params[:topic][:forumcategory_id])
      @forum = Forumcategory.find_by_id(params[:topic][:forumcategory_id])
      @forum.messages_count = @forum.messages_count + @topic.message_count
      @forum.topics_count = @forum.topics_count + 1       
      @forum.save
      redirect_to viewtopic_url(:id => @topic.id)
    end
  end

  def viewreports
    if !@logged_in
      return hit_error(403)
    end
    
    @message = Forummessage.find(params[:id])
    @topic = @message.forumtopic
    @forum = @topic.forumcategory
    
    @title = "Meldingen uit #{@topic.title}"
    
    if !@me.role.forum_can('mod', 'forum', @topic.forumcategory_id)
      return hit_error(403)
    end
    
    @reports = Forumreport.find(:all, :conditions => { forummessage_id: @message.id }, :include => :user)
    
  end

  def deletereport
    if !@logged_in
      return hit_error(403)
    end
    
    if !params[:id]
      return hit_error(404)
    end
    @report = Forumreport.find(params[:id])
    @message = Forummessage.find(@report.forummessage_id)
    @topic = @message.forumtopic
    @forum = @topic.forumcategory
    
    if !@me.role.forum_can('mod', 'forum', @topic.forumcategory_id)
      return hit_error(403)
    end
    
    @message.update_attribute('reportcount', (@message.reportcount - 1))
    @report.destroy
    flash[:notice] = 'Melding verwijderd'
    redirect_to viewreports_url(:id => @message.id)
  end

end
