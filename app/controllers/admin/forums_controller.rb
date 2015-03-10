class Admin::ForumsController < ApplicationController
  before_filter :require_admin
  layout 'admin'

  def index
    @forums = Forumparentcategory.find(:all, :include => 'forumcategories')
    @title = 'Forums'
  end
  def createparentcategory
    if !params[:parentcategory][:title].blank?
      Forumparentcategory.create(:title => params[:parentcategory][:title])
    else
      flash[:notice] = "Titel is leeg"
    end
    redirect_to :action => 'index'
  end
  def createcategory
    if !params[:forumcategory][:title].blank?
      fp = Forumcategory.create(params[:forumcategory])
      fp.update_attribute('forumparentcategory_id', params[:id])
    else
      flash[:notice] = "Titel is leeg"
    end
    redirect_to :action => 'index'
  end
  def editcategory
    if params[:id]
      @category = Forumparentcategory.find(params[:id])
      @title = @category.title
      if request.post?
        if !params[:category][:title].blank?
          @category.update_attribute('title', params[:category][:title])
        end
        redirect_to :action => 'index'
      end
    else
      hit_error(404)
    end
  end
  def deletecategory
    if params[:id]
      @category = Forumparentcategory.find(params[:id])
      @title = "Delete " + @category.title
      
      if request.post?
        @category.destroy
        redirect_to :action => 'index'
      end
    else
      hit_error(404)
    end
  end
  def editforum
    if !params[:id]
      hit_error(404)
    end
    @forumcategory = Forumcategory.find(params[:id])
    @title = @forumcategory.title
    if request.post?
      @forumcategory.update_attributes(params[:forumcategory])
      redirect_to :action => 'index'
    end
  end
  def deleteforum
    if !params[:id]
      hit_error(404)
    end
    @forum = Forumcategory.find(params[:id])
    if request.post?
      @forum.destroy
      flash['notice'] = 'Deleted forum'
      redirect_to :action => 'index'
    end
  end
  def forumpermissions
    @forum = Forumcategory.find(params[:id])
    @roles = Role.find(:all)
    @title = @forum.title
    @permissions = Forumpermission.find(:all, :conditions => 'parent_id = ' + @forum.id.to_s, :include => :role)
    if request.post? || request.put?
      if params[:forumpermission][:permission_id]
        #@permission = Forumpermission.find_by_id(params[:permission][:permission_id])
        #@permission.update_attributes(:action => params[:permission][:action], :role_id => params[:permission][:role_id], :can => params[:permission][:can])
        @permission = Forumpermission.find(params[:forumpermission][:permission_id])
        @permission.update_attributes(params[:forumpermission].except(:permission_id))
        redirect_to :action => 'forumpermissions', :id => params[:id]
      end
    end
  end
  def createpermission
    if params[:id]
      # permission for special forum
      Forumpermission.create(:action => params[:permission][:action], :mode => 'forum', :can => params[:permission][:can], :role_id => params[:permission][:role_id], :parent_id => params[:id])
      redirect_to :action => 'forumpermissions', :id => params[:id]
    else
      Forumpermission.create(:action => params[:permission][:action], :mode => 'board', :can => params[:permission][:can], :role_id => params[:permission][:role_id], :parent_id => '0')
      redirect_to :action => 'permissions'
  
    end
  end
  def permissions
    @permissions = Forumpermission.find(:all, :conditions => "mode = 'board'", :include => :role)
    @roles = Role.find(:all)
    @title = 'Permissions'
    if request.post? || request.put?
      @permission = Forumpermission.find(params[:forumpermission][:id])
      @permission.update_attributes(params[:forumpermission])
      redirect_to :action => 'permissions'
    end
  end
end
