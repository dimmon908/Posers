class FavorietenController < ApplicationController
  layout 'wide'
  def index
    if @logged_in
      @favorieten = Favourite.paginate(:conditions => 'user_id = ' + @me.id.to_s, :limit => 10, :include => [:kunstvoorwerp, :user], :per_page => 50, :page => params[:page])
    else
      flash[:notice] = 'Om van deze dienst gebruik te maken moet je ingelogged zijn.'
      redirect_to root_url
    end
  end

end
