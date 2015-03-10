class Admin::WebimagesController < ApplicationController
  before_filter :require_admin
  layout 'admin'
  
  def index
    if request.post?
      if params[:afbeelding]
        wi = Webimage.create(params[:afbeelding])
      else
        flash[:notice] = "Select the image"
      end
      redirect_to :action => 'index'
    end
    @images = Webimage.find(:all)
  end
  def delete
    if params[:id]
      wiz = Webimage.find(params[:id])
      wiz.destroy
      redirect_to :action => 'index'
    else
      hit_error(404)
    end
  end
end
