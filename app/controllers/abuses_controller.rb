class AbusesController < ApplicationController
  layout 'wide'
  def index
    if @me.can('admin')
      @sitemeldingen = Abusereport.paginate(:include => [{:kunstvoorwerp => :user}, :user, {:reply => :user}] , :per_page => 30, :page => params[:page])
      
    else
      hit_error(403)
    end
  end

  def destroy
    if @me.can('admin')
      ab = Abusereport.find(params[:id])
      ab.destroy

      redirect_to :action => 'index'
    else
      hit_error(403)
    end
  end
end
