class KunstenaarController < ApplicationController

  def index
    @kv = Kunstvoorwerp.find(params[:kunstid],
                             :include => [:user, {:kunstproperties => :propertycontainer}],
                             :conditions => "active = true")
    @kv.update_attribute('views', @kv.views + 1)

    #meta stuff
    @meta_description = @kv.description
    @meta_keywords = @kv.tags
    
    @title = @kv.title
    if request.post? and params[:reply] and @logged_in
      @reply = Reply.new()
      @reply.raw = params[:reply][:raw]
      @reply.processed = params[:reply][:raw]
      @reply.user_id = @me.id
      @kv.update_attribute('reacties', @kv.reacties + 1)
      @reply.kunstvoorwerp_id = @kv.id

      if @reply.raw.size > 3
        @reply.save
        if @kv.houmeopdehoogte
          Kunstmail.reactiemail(current_user,
                                 @kv,
                                 @reply.raw,
                                 url_for(werk_url(:name => @kv.user.intname, :kunstid => @kv.id))).deliver
        end

        redirect_to werk_url(:kunstid => @kv.id, :name => @kv.user.intname) and return
      else
        @reply.errors[:base] << "Uw bericht is te kort."
      end
    else
      if request.post? and params[:reply] 
        flash[:notice] = 'Je bent niet ingelogged. Om reacties te plaatsen moet je ingelogged zijn.'
      end
    end

    # yutup balk
    @ssid = ''
    @cp = 0
    @artperpage = 20.0
    if params[:ssid] and !params[:ssid].blank?
      # search session id present
      @ssid = params[:ssid]
      
      if !session[@ssid].blank?
        spage = 0
        if params[:cp] and !params[:cp].blank? and is_a_number?(params[:cp])
          spage = params[:cp]
          @cp = spage
         spage = spage.to_i * 20
        end
        @kvs = Kunstvoorwerp.find(:all, :conditions => session[@ssid][:where], :include => [:kunstimage, :user, :favourites], 
        :joins => "LEFT JOIN kprops ON kprops.kunstvoorwerp_id = kunstvoorwerps.id", 
        :order => session[@ssid][:sort], :offset => spage, :limit => 20, :select => "distinct kunstvoorwerps.*")
      else
        spage ||= 0
        @kvs = Kunstvoorwerp.actives.where(user_id: @kv.user_id).
          joins("LEFT JOIN kprops ON kprops.kunstvoorwerp_id = kunstvoorwerps.id").
          order('kunstvoorwerps.created_at DESC').includes(:kunstimage, :user, :favourites).limit(20).offset((spage*2)).select("distinct kunstvoorwerps.*")
      end
    else
      # haal alle gerelateerde onderwerpen bij deze kunstenaar op
      @kvs = Kunstvoorwerp.actives.where(user_id: @kv.user_id).
        joins("LEFT JOIN kprops ON kprops.kunstvoorwerp_id = kunstvoorwerps.id").
        order('kunstvoorwerps.created_at DESC').includes(:kunstimage, :user).limit(20).select("distinct kunstvoorwerps.*")
    end
    
    #
    #replies
    #
    countarr = Reply.count(:conditions => 'kunstvoorwerp_id = ' + @kv.id.to_s)
    max = 10.0
    @currentpage = 0
    spage = 0
    if params[:rp]
      spage = params[:rp].to_i * max
      @currentpage = params[:rp].to_i
    end
      
    #favs en apps  
    if @logged_in
      app = Appreciation.find_by_kunstvoorwerp_id(@kv.id, :conditions => 'user_id = ' + @me.id.to_s)
      fav = Favourite.find_by_kunstvoorwerp_id(@kv.id, :conditions => 'user_id = ' + @me.id.to_s)
      
      if app.blank?
        @app = false
      else
        @app = true
      end
      if fav.blank?
        @fav = false
      else
        @fav = true
      end
    else
      @fav = false
      @app = false
    end
      
    @pagecount = countarr / max
    @pagecount = @pagecount.ceil
    @reacties = Reply.find(:all, :conditions => 'kunstvoorwerp_id = ' + @kv.id.to_s, :offset => spage, :limit => max, :include => :user, :order => 'created_at ASC')
    
    @tags = @kv.tags.split(" ")
  end

  # shows info about the artist
  def show
    @kunstenaar = User.find_by_intname(params[:name])
    if @kunstenaar.blank?
      hit_error(404) and return
    end
    if (!@kunstenaar.voornaam.blank? and !@kunstenaar.achternaam.blank? and !@kunstenaar.profile_description.blank?)
      @meta_description = @kunstenaar.voornaam + " " + @kunstenaar.achternaam + ", " + @kunstenaar.profile_description[0..200]
    end
    if (!@kunstenaar.profile_disciplines.blank?)
      @meta_keywords = @kunstenaar.profile_disciplines
    end
    if !@kunstenaar.can('xpose')
      flash[:notice] = "Kunstenaar niet gevonden"
      redirect_to root_url and return
    end
    
    # info over de kunstenaar
    if !@kunstenaar.profile_cv.blank?
      @pcv = @kunstenaar.profile_cv.split("\n")
    end
    if !@kunstenaar.profile_exposities.blank?
      @pexpo = @kunstenaar.profile_exposities.split("\n")
    end
    if !@kunstenaar.profile_prijzen.blank?
      @pawards = @kunstenaar.profile_prijzen.split("\n")
    end
    if !@kunstenaar.profile_opleidingen.blank?
      @opleidingen = @kunstenaar.profile_opleidingen.split("\n")
    end
    if !@kunstenaar.profile_disciplines.blank?
      @disciplines = @kunstenaar.profile_disciplines.split("\n")
    end

    @title =  "#{@kunstenaar.voornaam} #{@kunstenaar.achternaam}"
    
    # paginering en rest
    max = 20.0
    if !params[:page]
      spage = 0
      @cp = ''
    else
      spage = params[:page].to_i * max
      @cp = params[:page]
    end
    
    countarr = Kunstvoorwerp.count(
                :all, 
                :conditions => 'kunstvoorwerps.active = true AND kunstvoorwerps.user_id = ' + @kunstenaar.id.to_s, 
                :order => 'kunstvoorwerps.created_at DESC')
    
    @pagecount = countarr/max  
    @pagecount = @pagecount.ceil
    @kvs = Kunstvoorwerp.find(:all, 
                              :conditions => 'kunstvoorwerps.active = true AND kunstvoorwerps.user_id = ' + @kunstenaar.id.to_s, 
                              :order => 'kunstvoorwerps.created_at DESC',
                              :select => 'distinct kunstvoorwerps.*',
                              :offset => spage,
                              :limit => max)
  end

  # Lists artists by first letter from second name
  def kunstenaars
    
    # finding artist roles
    @permissionsu = Role.find(:all, :include => [:permissions], :conditions => 'permissions.name = \'xpose\'')
    @permissionsu.reject! { |role| role.name == 'admin' }

    rolestring = ''
    i = 0
    @permissionsu.each do |p|
      if i == 0
        rolestring = 'role_id = \'' + p.id.to_s + '\''
        i = 1
      else
        rolestring = rolestring + ' XOR role_id = \'' + p.id.to_s + '\''
      end
      
    end
    
    # arrays for artists
    @a1 = Array.new
    @a2 = Array.new
    @a3 = Array.new
    @a4 = Array.new    
    
    if params[:page].blank? or params[:page].to_i == 0
      @kunstenaars = User.find(:all, 
        :conditions => "(UPPER(achternaam) LIKE 'A%' OR UPPER(achternaam) LIKE 'B%' 
                            OR UPPER(achternaam) LIKE 'C%' OR UPPER(achternaam) LIKE 'D%') AND (" + rolestring + ")",
        :order => "achternaam ASC"
      )
      @kunstenaars.each do |k|
        achternaam = k.achternaam[0..0].capitalize
        
        if achternaam == 'A'
          @a1.push k
        elsif achternaam == 'B'
          @a2.push k
        elsif achternaam == 'C'
          @a3.push k
        elsif achternaam == 'D'
          @a4.push k
        end
      end
    elsif params[:page].to_i == 1

      # UPPER function called to make query compatible with both MYSQL and POSTGRES
      @kunstenaars = User.find(:all, 
        :conditions => "
          (UPPER(achternaam) LIKE 'E%' OR UPPER(achternaam) LIKE 'F%' OR UPPER(achternaam) LIKE 'G%') 
          AND (" + rolestring + ")",
        :order => "achternaam ASC"
      )
      @kunstenaars.each do |k|
        achternaam = k.achternaam[0..0].capitalize
        if achternaam == 'E'
          @a1.push k
        elsif achternaam == 'F'
          @a2.push k
        elsif achternaam == 'G'
          @a3.push k
        end
      end
    elsif params[:page].to_i == 2
      @kunstenaars = User.find(:all, 
        :conditions => '(UPPER(achternaam) LIKE \'I%\' OR UPPER(achternaam) LIKE \'J%\' OR UPPER(achternaam) LIKE \'H%\') 
          AND (' + rolestring + ')',
        :order => "achternaam ASC"
      )
      @kunstenaars.each do |k|
        achternaam = k.achternaam[0..0].capitalize
        if achternaam == 'H'
          @a1.push k
        elsif achternaam == 'I'
          @a2.push k
        elsif achternaam == 'J'
          @a3.push k
        end
      end
    elsif params[:page].to_i == 3
      @kunstenaars = User.find(:all, 
        :conditions => '(UPPER(achternaam) LIKE \'M%\' OR UPPER(achternaam) LIKE \'N%\' OR UPPER(achternaam) LIKE \'K%\') AND (' + rolestring + ')',
        :order => "achternaam ASC"
      )
      @kunstenaars.each do |k|
        achternaam = k.achternaam[0..0].capitalize
        if achternaam == 'K'
          @a1.push k
        elsif achternaam == 'L'
          @a2.push k
        elsif achternaam == 'M'
          @a3.push k
        elsif achternaam == 'N'
          @a4.push k
        end
      end
    elsif params[:page].to_i == 4
      @kunstenaars = User.find(:all, 
        :conditions => '(UPPER(achternaam) LIKE \'O%\' OR UPPER(achternaam) LIKE \'P%\' OR UPPER(achternaam) LIKE \'Q%\' 
                          OR UPPER(achternaam) LIKE \'R%\') AND (' + rolestring + ')',
        :order => "achternaam ASC"
      )
      @kunstenaars.each do |k|
        achternaam = k.achternaam[0..0].capitalize
        if achternaam == 'O'
          @a1.push k
        elsif achternaam == 'P'
          @a2.push k
        elsif achternaam == 'Q'
          @a3.push k
        elsif achternaam == 'R'
          @a4.push k
        end
      end
    elsif params[:page].to_i == 5
      @kunstenaars = User.find(:all, 
        :conditions => "
          (UPPER(achternaam) LIKE 'S%' OR UPPER(achternaam) LIKE 'T%' OR UPPER(achternaam) LIKE 'U%' OR UPPER(achternaam) LIKE 'V%') 
          AND (" + rolestring + ")",
        :order => "achternaam ASC"
        )
      @kunstenaars.each do |k|
        achternaam = k.achternaam[0..0].capitalize
        if achternaam == 'S'
          @a1.push k
        elsif achternaam == 'T'
          @a2.push k
        elsif achternaam == 'U'
          @a3.push k
        elsif achternaam == 'V'
          @a4.push k
        end
      end
    elsif params[:page].to_i == 6
      @kunstenaars = User.find(:all, 
        :conditions => '(UPPER(achternaam) LIKE \'W%\' OR UPPER(achternaam) LIKE \'X%\' OR UPPER(achternaam) LIKE \'Y%\' 
                          OR UPPER(achternaam) LIKE \'Z%\') AND (' + rolestring + ')',
        :order => "achternaam ASC"
      )
      @kunstenaars.each do |k|
        achternaam = k.achternaam[0..0].capitalize
        if achternaam == 'W'
          @a1.push k
        elsif achternaam == 'X'
          @a2.push k
        elsif achternaam == 'Y'
          @a3.push k
        elsif achternaam == 'Z'
          @a4.push k
        end
      end
    elsif params[:page].to_i == 7
      @kunstenaars = User.find(:all, 
        :conditions => '(
          UPPER(achternaam) NOT LIKE \'A%\' AND UPPER(achternaam) NOT LIKE \'B%\' AND 
          UPPER(achternaam) NOT LIKE \'C%\' AND UPPER(achternaam) NOT LIKE \'D%\' AND 
          UPPER(achternaam) NOT LIKE \'E%\' AND UPPER(achternaam) NOT LIKE \'F%\' AND 
          UPPER(achternaam) NOT LIKE \'G%\' AND UPPER(achternaam) NOT LIKE \'H%\' AND 
          UPPER(achternaam) NOT LIKE \'I%\' AND UPPER(achternaam) NOT LIKE \'J%\' AND 
          UPPER(achternaam) NOT LIKE \'K%\' AND UPPER(achternaam) NOT LIKE \'L%\' AND 
          UPPER(achternaam) NOT LIKE \'M%\' AND UPPER(achternaam) NOT LIKE \'N%\' AND 
          UPPER(achternaam) NOT LIKE \'O%\' AND UPPER(achternaam) NOT LIKE \'P%\' AND 
          UPPER(achternaam) NOT LIKE \'Q%\' AND UPPER(achternaam) NOT LIKE \'R%\' AND 
          UPPER(achternaam) NOT LIKE \'S%\' AND UPPER(achternaam) NOT LIKE \'T%\' AND 
          UPPER(achternaam) NOT LIKE \'U%\' AND UPPER(achternaam) NOT LIKE \'V%\' AND 
          UPPER(achternaam) NOT LIKE \'W%\' AND UPPER(achternaam) NOT LIKE \'X%\' AND 
          UPPER(achternaam) NOT LIKE \'Y%\' AND UPPER(achternaam) NOT LIKE \'Z%\') AND (' + rolestring + ')',
        :order => "achternaam ASC"
      )
      @kunstenaars.each do |k|
        achternaam = k.achternaam[0..0].capitalize
        if (achternaam.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true)
          @a1.push k
        else
          @a2.push k
        end
      end
    end
  end
end
