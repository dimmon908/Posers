class Forum::MessagesController < ApplicationController
  layout 'forum'
  before_filter :forum_permissions
  before_filter :find_message_and_check_permissions

  def destroy
    @message.destroy

    @forum.messages_count = @forum.messages_count - 1 
    @topic.message_count = @topic.message_count - 1

    @topic.lastreply_user_id = @topic.forummessages.last.user_id
    @forum.lastreply_user_id = @forum.messages_count - 1 

    @topic.save
    @forum.save

    redirect_to viewtopic_url(:id => @topic.id)
  end

  private
    def find_message_and_check_permissions
      @message = Forummessage.includes(:forumtopic).find(params[:id])
      return hit_error(403) if @message.topicstart

      @topic = @message.forumtopic
      @forum = @topic.forumcategory

      if !@me.role.forum_can('mod', 'forum', @forum.id)
        return hit_error(403)
      end
    end
end
