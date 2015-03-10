class KunstController < ApplicationController
  layout 'kunst'

  def index
  end

  def search
  end

  # TODO Nest all queries params into a :conditions hash
  # Pass that hash to a model method so model can deal with theses
  # queries instead of letting this giant controller method here
  #
  def results
    @title = 'zoeken'

    # lets search
    squery = 'active = true'
    if params[:type] and params[:type] != '' and is_a_number?(params[:type]) and params[:type] != '0'
      squery = squery + ' AND kunstvoorwerps.type_id = ' + params[:type]
    end
    #zoekopdracht
    if params[:q] and !params[:q].blank?
      squery = squery + " AND UPPER(kunstvoorwerps.sfield) LIKE UPPER('%#{params[:q]}%')"
    end
    #prijs
    if params[:p1] and is_a_number?(params[:p1]) and !params[:p1].blank?
      squery = squery + " AND kunstvoorwerps.prijs > '#{params[:p1]}'"
    end
    if params[:p2] and is_a_number?(params[:p2]) and !params[:p2].blank?
      squery = squery + " AND kunstvoorwerps.prijs < '#{params[:p2]}'"
    end
    
    if params[:mat] and !params[:mat].blank?
      squery = squery + " AND kunstvoorwerps.material LIKE '%#{params[:mat]}%'"
    end
    
    if params[:conditions]
      # show works for sale
      if params[:conditions][:for_sale]
        squery += " AND kunstvoorwerps.status = 0"
      end

      # show works for rent
      if params[:conditions][:for_rent]
        squery += " AND kunstvoorwerps.for_rent = true"
      end
    end

    #breedte
    if params[:fb1] and is_a_number?(params[:fb1]) and !params[:fb1].blank?
      squery = squery + " AND kunstvoorwerps.width > '#{params[:fb1]}'"
    end
    if params[:fb2] and is_a_number?(params[:fb2]) and !params[:fb2].blank?
      squery = squery + " AND kunstvoorwerps.width < '#{params[:fb2]}'"
    end
    #hoogte
    if params[:fh1] and is_a_number?(params[:fh1]) and !params[:fh1].blank?
      squery = squery + " AND kunstvoorwerps.height > '#{params[:fh1]}'"
    end
    if params[:fh2] and is_a_number?(params[:fh2]) and !params[:fh2].blank?
      squery = squery + " AND kunstvoorwerps.height < '#{params[:fh2]}'"
    end   
    
    if params[:property] and !params[:property].blank?
      squery = squery +  " AND kprops.kunstproperty_id = " + sanitize_int(params[:property])
    end
        
    if params[:properties] and !params[:properties].blank?
      zq = " AND kunstvoorwerps.id IN ( SELECT kunstvoorwerp_id FROM kprops WHERE "
      zq2 = ""
      i = 0
      params[:properties].each do |p|
        if p[1] != '0'
          if i == 0
            zq2 = " kprops.kunstproperty_id = " + sanitize_int(p[1])
          else
            zq2 = zq2 + " AND kprops.kunstproperty_id = " + sanitize_int(p[1])
          end
          i = 2
        end
      end
      zq = zq + zq2 + " )"
      
      if !zq2.blank?
        squery = squery + zq
      end
    end

    if params[:page]
      page = params[:page]
      if page == '0'
        page = 1
      end
    else
      page = 1
    end
    
    sort = "kunstvoorwerps.created_at DESC"
    if params[:sort] and !params[:sort].blank?
      if params[:sort] == 'date'
        sort = "kunstvoorwerps.created_at DESC"
      elsif params[:sort] == 'views'
        sort = "kunstvoorwerps.views DESC, kunstvoorwerps.created_at DESC"
      elsif params[:sort] == 'app'
        sort = "kunstvoorwerps.appcount DESC, kunstvoorwerps.created_at DESC"
      elsif params[:sort] == 'replies'
        sort = "kunstvoorwerps.reacties DESC, kunstvoorwerps.created_at DESC"
      else
        sort = "kunstvoorwerps.created_at DESC"
      end
    end
    
    # search session id
    # TODO it causes overflow cookie errors, should be refactored and maybe use
    # database sessions
    #
    if !params[:ssid]
      @ssid = "sd" + Digest::SHA1.hexdigest(Time.now.to_s + "adijadijdaji" + Time.now.to_s)
      session[@ssid] = {}
      if params[:favs] && current_user
        squery = squery + " AND favourites.user_id = #{current_user.id}"
      end
      session[@ssid][:where] = squery
      session[@ssid][:sort] = sort
    else
      @ssid = params[:ssid]
      if session[@ssid]
        squery = session[@ssid][:where]
        sort = session[@ssid][:sort]
      end
    end
    
    # sorteer opties 
    max = 20.0
    if !params[:page]
      spage = 0
      @cp = ''
    else
      spage = (params[:page].to_i * max).ceil
      @cp = params[:page]
    end

    @kvs = Kunstvoorwerp.includes(:kunstimage, :user, :favourites)
                        .where(squery)
                        .offset(spage)
                        .paginate(:page => params[:page], :per_page => 16)
                        .order(sort)
  end

  def bekijkwerk
    @kv = Kunstvoorwerp.find(params[:id])
  end

  def closeup
    @kv = Kunstvoorwerp.find(params[:id], include: 'closeup', order: 'closeups.id DESC')
    hit_error(404) if @kv.closeup_id.blank?
  end

  def wijzigreactie
    @reactie = Reply.find(params[:id])
    if @reactie.user.id == @me.id or @me.can('admin')
      if request.post? and params[:reply]
        @reactie.raw = params[:reply][:raw]
        @reactie.processed = params[:reply][:raw]
        
        # admin opties
        if params[:modtextenabled] and @me.can('admin') and !params[:modtext].blank?
          Kunstmail.reactieedit(@reactie.user.email, @reactie.user.nickname, params[:modtext], werk_url(:name => @reactie.kunstvoorwerp.user.intname, :kunstid => @reactie.kunstvoorwerp.id)).deliver
        end
        
        if @reactie.save
          flash[:notice] = 'Reactie gewijzigd'
          redirect_to werk_url(:name => @reactie.kunstvoorwerp.user.intname, :kunstid => @reactie.kunstvoorwerp.id)
        end
      end
    else
      return hit_error(403)
    end
  end

  def verwijderreactie
    @reactie = Reply.find(params[:id])
    if @me.can('admin')
      kunstid = @reactie.kunstvoorwerp.id
      @reactie.kunstvoorwerp.update_attribute('reacties', @reactie.kunstvoorwerp.reacties - 1)
      naam = @reactie.kunstvoorwerp.user.intname
      @reactie.delete

      redirect_to werk_url(:name => naam, :kunstid => kunstid), notice: 'Reactie verwijderd'
    else
      return hit_error(403)
    end
  end

  def fav
    if @logged_in and params[:id]    
      fav = Favourite.find_by_kunstvoorwerp_id(params[:id], :conditions => 'user_id = ' + @me.id.to_s)
      if fav.blank?
        @kv = Kunstvoorwerp.find_by_id(params[:id])
        if !@kv.blank?
          @kv.update_attribute('favcount', @kv.favcount + 1)
          fav = Favourite.create(:kunstvoorwerp_id => @kv.id, :user_id => @me.id)
          redirect_to werk_url(:name => @kv.user.intname, :kunstid => @kv.id)
        else
          return hit_error(404)
        end
      else
        @kv = Kunstvoorwerp.find_by_id(params[:id])
        if !@kv.blank?  
          @kv.update_attribute('favcount', @kv.favcount - 1)
          
          fav.delete
          redirect_to werk_url(:name => @kv.user.intname, :kunstid => @kv.id)
        else
          return hit_error(404)
        end
      end
    else
      if !params[:id]
        return hit_error(404)
      end
    end
  end

  def app
    if @logged_in and params[:id]
      app = Appreciation.find_by_kunstvoorwerp_id(params[:id], :conditions => 'user_id = ' + @me.id.to_s)
      if app.blank?
        @kv = Kunstvoorwerp.find_by_id(params[:id])
        if @kv.user_id == @me.id
          flash[:notice] == 'Je kunt aan je eigen werk geen waarderingen toevoegen.'
          redirect_to werk_url(:name => @kv.user.intname, :kunstid => @kv.id)
        else
           if !@kv.blank?
              @kv.update_attribute('appcount', @kv.appcount + 1)
              app = Appreciation.create(:kunstvoorwerp_id => @kv.id, :user_id => @me.id)
              redirect_to werk_url(:name => @kv.user.intname, :kunstid => @kv.id)
            else
              return hit_error(404)
            end
        end
      else
        @kv = Kunstvoorwerp.find_by_id(params[:id])
        if !@kv.blank?  
          @kv.update_attribute('appcount', @kv.appcount - 1)
          app.delete
          redirect_to werk_url(:name => @kv.user.intname, :kunstid => @kv.id)
        else
          return hit_error(404)
        end
      end
    else
      if !params[:id]
        return hit_error(404)
      end
    end
  end  

  # resizes artwork when necessary until it has smaller dimensions than
  # interieur images
  #
  def resizes_if_necessary
    if(@kv_height > @interieur_height || @kv_width > @interieur_width)
      @kv_height = (@kv_height / 2).ceil  
      @kv_width = (@kv_width / 2).ceil  
      resizes_if_necessary
    end
  end

  # It should show an Interiour image uploaded by the logged in user
  # and below it a grid with results from which the artwork was found.
  # The search query is kept on session[:ssid].
  # If artwork was not found through search it lists artwork from the same owner.
  # Inside / On top of interieur image should appear the artwork selected by the user
  #
  def interieur
    @kv = Kunstvoorwerp.includes(:kunstimage).find(params[:id])
    @kv_width = (@kv.kunstimage.dimensions.width / 3).ceil
    @kv_height = (@kv.kunstimage.dimensions.height / 3).ceil

    if params[:int] and @logged_in
      @interieur = Interieur.find_by_id(params[:int], conditions: { user_id: current_user.id})
      @interieur_height = @interieur.dimensions.height
      @interieur_width = @interieur.dimensions.width

      resizes_if_necessary
    else
      if @logged_in and !@me.interieurs.blank?
        if params[:ssid]
          if params[:cp]
            redirect_to :int => @me.interieurs[0].id, :ssid => params[:ssid], :cp => params[:cp]
          else
            redirect_to :int => @me.interieurs[0].id, :ssid => params[:ssid]
          end
        else
          redirect_to :int => @me.interieurs[0].id
        end
      end
    end
    
    @cp = 0
    if params[:ssid]
      # search session id
      @ssid = params[:ssid]
      if session[@ssid]
        spage = 0
        if params[:cp] and !params[:cp].blank? and is_a_number?(params[:cp])
          spage = (params[:cp].to_i * 20).ceil
          @cp = params[:cp]
        end
        @kvs = Kunstvoorwerp.find(:all, 
                                  :conditions => session[@ssid][:where], 
                                  :include => [:kunstimage, :user, :favourites],
                                  :order => session[@ssid][:sort], :offset => spage,
                                  :limit => 20)
      end
    else
      @kvs = Kunstvoorwerp.find(:all,
                                :conditions => { active: true, user_id: @kv.user_id },
                                :order => 'kunstvoorwerps.created_at DESC',
                                :limit => 20)
    end
    @title = @kv.title  
  end

  def wijzig
    if !params[:id]
      return hit_error(404)
    end
    if !@logged_in 
       return hit_error(403)
     end
    @kunst = Kunstvoorwerp.find(params[:id])
    if (@kunst.user_id != @me.id and !@me.can('admin'))
      return hit_error(403)
    end
    @kop = []
    @kunst.kprops.each do |k|
      @kop.push k.kunstproperty_id
    end  
    if request.post?
      if params[:kunst][:prijs].blank? or !is_a_number?(params[:kunst][:prijs])
        prijs = params[:kunst][:prijs].gsub(/,/, '.')
        if !is_a_number?(prijs.to_i)
          prijs = 0
        end
      else
        prijs = params[:kunst][:prijs]
      end
      @kunst.update_attributes({
          :for_rent => params[:kunst][:for_rent],
          :title => params[:kunst][:title],
          :prijs => prijs,
          :description => params[:kunst][:description],
          :tags => params[:kunst][:tags],
          :verzendmethode => params[:kunst][:verzendmethode],
          :height => params[:kunst][:height],
          :width => params[:kunst][:width],
          :depth => params[:kunst][:depth],
          :material => params[:kunst][:material],
          :status => params[:kunst][:status],
          :type_id => params[:kunst][:type],
          :houmeopdehoogte => params[:kunst][:houmeopdehoogte]
      })
      
      @kunst.kprops.destroy_all
      @kunst.sfield = @kunst.title + " " + @kunst.description + " " + @kunst.tags
      @kunst.save
      
  
      tsel = Type.find_by_id(params[:kunst][:type])
      tsel.propertycontainers.each do |c|
        a = 'c' + c.id.to_s
        if params[:properties][a]
          
          kpz = Kprop.create(:kunstproperty_id => params[:properties][a], :kunstvoorwerp_id => @kunst.id)
        end
      end

      @kunst.kunstproperties.each do |kp|
        @kunst.sfield = @kunst.sfield + kp.title
      end
      
      @kunst.sfield = "#{@kunst.sfield} #{@kunst.user.voornaam} #{@kunst.user.achternaam}"
      @kunst.sfield.strip
      if @kunst.save
        flash[:notice] = "Kunstvoorwerp succesvol bijgewerkt. "
        if @kunst.kunstimage.blank?
          redirect_to mijnkunst_url
        else
          redirect_to werk_url(:name => @kunst.user.intname, :kunstid => @kunst.id)
        end
      end
    end
  end

  def verwijder
    if !params[:id]
      return hit_error(404)
    end
    if !@logged_in 
       return hit_error(403)
     end
    @kunst = Kunstvoorwerp.find(params[:id])
    if (@kunst.user_id != @me.id and !@me.can('admin'))
      return hit_error(403)
    end
    if request.post?
      if !@kunst.kunstimage.blank?
        @kunst.kunstimage.destroy
      end
      @kunst.kprops.destroy_all
      @kunst.replies.destroy_all
      @kunst.favourites.destroy_all
      @kunst.appreciations.destroy_all
      @kunst.destroy
      flash[:notice] = "Kunstvoorwerp verwijderd."
      redirect_to mijnkunst_url
    end
  end

  def misbruik
    return hit_error(404) if !params[:id]
    return hit_error(403) if !@logged_in

    @kv = Kunstvoorwerp.find(params[:id])

    if request.post?
      Abusereport.create(:user_id => current_user.id, :message => params[:abuse][:message], :kunstvoorwerp_id => params[:id])
      redirect_to werk_url(:name => @kv.user.intname, :kunstid => @kv.id)
      flash[:notice] = 'De melding is opgeslagen en verzonden aan de beheerders'
    end
  end
end
