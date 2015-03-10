class XposeController < ApplicationController
  layout 'wide'

  before_filter :redirect_to_index, except: :index
  
  # Always show index it user not logged in
  def redirect_to_index
    redirect_to :action => 'index' unless current_user
    @user = current_user
  end

  # Only shows some text with link to loggin page
  def index
    redirect_to :nieuw if current_user
  end

  # Updates user info. Converts user into artist (kunstenaar)
  #
  def update

    @kunstenaarsrol = Role.find_by_name('kunstenaar')
    if @kunstenaarsrol.blank?
      @kunstenaarsrol = Role.create(:name => 'kunstenaar')
      @kunstenaarsrol.permissions.create(:name => 'xpose')
    end

    params[:user][:role] = @kunstenaarsrol
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Je account is nu omgezet en je kunt nu exposeren.'
      redirect_to :action => 'nieuw'
    else
      render 'omzetten'
    end
  end

  # Render form for user if user is not admin or was already turned into artist
  # Clear users errors so message validations dont appear when form is first loaded
  #
  def omzetten
    if @me.can('admin')
      flash[:notice] = 'Geen goed plan lijkt me, verlies je je beheer rechten... '
      redirect_to root_url
    elsif @me.can('xpose')
      redirect_to new_artwork_url
    end
    @user.errors.clear
  end

  def item
  end

  def updateafbeelding
    @kv = Kunstvoorwerp.find(params[:id])
    @kv.kunstimage.square('square', 188)
    @kv.kunstimage.square('square_small', 90)
    @kv.kunstimage.resize('info', 465, 465)
    @kv.kunstimage.resize('larger', 610, 610)
    @kv.kunstimage.setsize
  end

  # upload main pic and close up for an artwork
  def plaatsafbeelding
    @kv = Kunstvoorwerp.find(params[:id])
    if @me.can('xpose') and (@kv.user_id == @me.id or @me.can('admin'))
       if request.post?
        if params[:closeup] && params[:closeup][:image]
          cl = Closeup.create(params[:closeup])
          cl.update_attribute(:kunstvoorwerp_id, @kv.id)
          @kv.update_attribute(:closeup_id, cl.id)
          unless params[:kunstimage] && params[:kunstimage][:image]
            # flash[:notice] = 'Afbeelding succesvol geplaatst'
            # redirect_to werk_url(:name => @kv.user.intname, :kunstid => @kv.id)
            render :json => { :name => cl.image.instance.attributes["image_file_name"] }, :content_type => 'text/html'
          end
        end
        
        if params[:kunstimage] && params[:kunstimage][:image]
          if @kv.kunstimage
            @kv.kunstimage.destroy
            @kv.update_attribute :active, false
          end
          
          image = Kunstimage.create!(params[:kunstimage])
          # flash[:notice] = 'Afbeelding succesvol geplaatst'
          if image.update_attribute(:kunstvoorwerp_id, @kv.id) && @kv.update_attributes(:active => true, :kunstimage_id => image.id)
            # redirect_to werk_url(:name => @kv.user.intname, :kunstid => @kv.id)
            render :json => { :path => image.url('square_small'), :name => image.image.instance.attributes["image_file_name"] }, :content_type => 'text/html'
          else
            redirect_to :action => 'plaatsafbeelding'
          end
        end
      else
        @afbeelding = Kunstimage.new()
      end
    else
      redirect_to root_url
    end
  end
end
