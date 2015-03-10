class GebruikerController < ApplicationController
  layout 'wide'
  before_filter :redirect_403, only: [:profiel, :avatar, :uploadavatar, :upload, :setdefaultavatar, :deleteavatar]

  # hit error if user is not logged in
  def redirect_403
    return hit_error(403) unless current_user
  end
   
  def login
    if @logged_in
      redirect_to root_url and return
    end
    @title = "Inloggen"
    @keeploggedin = 0
    if request.get?
      if session[:user_id]
        redirect_to :controller => 'site'
      end
    end
    if request.post? and (params[:user] or params[:userlogin])
      if params[:user]
        actparams = params[:user]
      else
        actparams = params[:userlogin]
      end

      if actparams[:keep_logged_in]
        @keeploggedin = 1
      else
        @keeploggedin = 0
      end
      if session[:user_id]
        redirect_to :controller => 'site'
      end
      @user = User.new()
      @user.password = Digest::SHA1.hexdigest(actparams[:password])
      @user.nickname = actparams[:nickname]

      user = User.find_by_nickname_and_password(@user.nickname, @user.password)
      if user
        if user.activated
          session[:user_id] = user.id
          if actparams[:keep_logged_in]
            unid = Digest::SHA1.hexdigest(Time.now.to_s + "adijadijdaji" + Time.now.to_s)
            cookies[:xposerslogin] = {
              :value => unid,
              :expires => 1.year.from_now,
            }
            user.login_sessions.create({:authentication_key => unid})
          end
          flash[:notice] = "Welkom terug, #{user.nickname}"
          if params[:user][:ref] and params[:user][:ref].gsub("/#{root_url}.*/", '') 
            redirect_to params[:user][:ref]
          else
            redirect_to :action => "index", :controller => 'site'
          end
          

        else
          @user.password = nil
          flash[:notice] = "Dit gebruikers account is nog niet geactiveerd"
        end
      else
        @user.password = nil
        flash[:notice] = "De aangegeven gebruikersnaam of wachtwoord is incorrect."
      end
    end
  end

  def loguit
    @title = "Uitloggen"
    if request.get?
      if !session[:user_id]
        redirect_to :action => "index", :controller => "site"
      end
    end
    if request.post?
      session[:user_id] = nil
      cookies.delete :xposerslogin
      flash[:notice] = "Je bent uitgelogd"
      redirect_to :action => "index", :controller => "site"
    end

  end

  # Updates user info. Need to manually add achternam param somehow.
  # not sure if this field is really necessary at all
  #
  def profiel
    if request.post? and params[:user]

      if @me.update_attributes(params[:user])
        # website stuff!
        if params[:user][:profile_website]
          if params[:user][:profile_website][0..6] != "http://" and !params[:user][:profile_website].blank?
            @me.update_attribute('profile_website', 'http://' + params[:user][:profile_website])
          end
        end
        flash.now[:notice] = "Profiel gewijzigd"
      end
    end
    
  end

  def register
    @title = "Aanmelden"
    @answer = '28'
    if request.post? and params[:user]
      @user = User.new()
      @user.nickname = params[:user][:nickname]
      @user.password = Digest::SHA1.hexdigest(params[:user][:password])
      @user.original_email = params[:user][:email]
      @user.email = params[:user][:email]
      @emailconf =  params[:user][:emailconf]
      @user.intname = @user.nickname.gsub(/\W*\s*/, "").downcase
      @passwordconf = ''
      @user.valid?
      @secqent = params[:user][:secquest]
      if params[:eula][:accepted] != 'yes'
        @user.errors.add_to_base("De algemene voorwaarden zijn niet geaccepteerd")
      end
      if params[:user][:password] != params[:user][:passwordconf]
        @user.errors.add_to_base("De wachtwoorden komen niet overeen")
      end
      if params[:user][:email] != params[:user][:emailconf]
        @user.errors.add_to_base("De e-mail adressen komen niet overeen")
      end
      if params[:user][:password].size < 3
        @user.errors.add_to_base("Het wachtwoord is te kort")
      end
      if params[:user][:secquest].strip != @answer
        @user.errors.add_to_base("De veiligheidsvraag is foutief beantwoord")
      end
      if @user.errors.empty?
        @user.unid = Digest::SHA1.hexdigest(Time.now.to_s + "keihardelolmetxposers" + Time.now.to_s)
        @user.save
        mail = Intmail.find_by_inttitle('user_new')

        if !mail.blank?
          nmail = mail.message
          nmail = nmail.gsub(/<username>/, @user.nickname)
          nmail = nmail.gsub(/<link>/, url_for({:controller => 'gebruiker', :action => 'activeer', :id => @user.unid}))
          Kunstmail.massmail(mail.title, @user.email, nmail).deliver
          
          
         
          
          redirect_to :action => "welkom"
        else
          @user.destroy
          return hit_error 500
        
        end
      else
        @user.password = nil
      end
    end
  end

  def activeer
    @user = User.find_by_unid(params[:id])
    if @user
      if @user.activated
        redirect_to root_url
      end
      @user.activated = true;
      @user.save
    else
      redirect_to root_url
    end
  end

  def welkom
    @title = "Welkom"
  end

  def wachtwoordkwijt
    if request.post?
      @user = User.find_by_nickname(params[:user][:nickname])
      if !@user.blank?
        
        mail = Intmail.find_by_inttitle('user_password')

        if !mail.blank?
          nmail = mail.message
          nmail = nmail.gsub(/<username>/, @user.nickname)
          nmail = nmail.gsub(/<link>/, url_for({:controller => 'gebruiker', :action => 'wachtwoordterugvinden', :id => @user.unid}))
          Kunstmail.massmail(mail.title, @user.email, nmail).deliver
          flash[:notice] = 'Een e-mail is naar je toe gestuurd met instructies voor het wijzigen van uw wachtwoord.'
          redirect_to root_url
        else
          hit_error 503
        end
      end
    end
  end
  def wachtwoordterugvinden
    if @logged_in
      flash[:notice] = 'Je bent al ingelogd'
      redirect_to root_url
    end
    @user = User.find_by_unid(params[:id])
    if @user.blank?
      flash[:notice] = 'Gezochte gebruiker bestaat niet'
      redirect_to root_url
    end

    if request.post?
      @user.password = Digest::SHA1.hexdigest(params[:user][:password])
      @user.valid?
      if params[:user][:password].size < 3
        @user.errors.add_to_base("Het wachtwoord is te kort")
      end
      if params[:user][:password] != params[:user][:passwordconf]
        @user.errors.add_to_base("De wachtwoorden komen niet overeen")
      end
      if @user.errors.empty?
        @user.unid = Digest::SHA1.hexdigest(Time.now.to_s + "keihardelolmetxposers" + Time.now.to_s)
        @user.save
        flash[:notice] = 'Je wachtwoord is succesvol gewijzigd'
        redirect_to login_url
      end
    end
  end
  def wachtwoord
    if !@logged_in
       return hit_error(403)
    end
    if request.post?
       @user = @me
       if params[:user][:password] != params[:user][:passwordconf]
          @user.errors.add_to_base("De wachtwoorden komen niet overeen")
       end
       if params[:user][:password].size < 3
         @user.errors.add_to_base("Het wachtwoord is te kort")
       end
       if @user.errors.blank?
         @user.password = Digest::SHA1.hexdigest(params[:user][:password])
         @user.save
         flash[:notice] = 'Wachtwoord succesvol gewijzigd'
         redirect_to profile_url
       end
    end
  end

  # Shows users avatars
  def avatar
  end

  # Show form for new user image upload
  # User cannot have more than 10 individual images
  def uploadavatar
    if @me.avatars.size > 9
      flash[:notice] = "Je kunt niet meer dan 10 persoonlijke afbeeldingen hebben."
      redirect_to myprofile_url and return
    end
    @avatar = Avatar.new
  end

  # upload new user pic and set it as default
  # POST
  def upload
    @avatar = Avatar.new params[:avatar]
    if @avatar.valid?
      if !@me.avatar.blank?
        @me.avatar.update_attribute('selected_avatar', false)
      end
      @avatar.user_id = @me.id
      @avatar.selected_avatar = true
      @avatar.save
      redirect_to avatar_url
      flash[:notice] = 'Persoonlijke afbeelding geplaatst.'
    else
      @avatar.errors.clear
      @avatar.errors.add_to_base('Foutieve avatar geupload. De file kan niet van het juiste type zijn (zorg voor een jpeg/png/gif afbeelding) of kan te groot zijn (probeer de file onder de 300 kb te houden).')
    end
  end

  # Set avatar as default
  def setdefaultavatar
    savatar = current_user.avatars.find_by_id(params[:id])
    if !@me.avatar.blank?
      @me.avatar.update_attribute('selected_avatar', false)
    end
    savatar.update_attribute('selected_avatar', true)
    redirect_to avatar_url
  end

  # Deletes avatar and set another one as default
  def deleteavatar
    savatar = current_user.avatars.find(params[:id])
    if savatar.selected_avatar
      current_user.avatars.first.update_attribute('selected_avatar', true)
    end
    savatar.delete
    redirect_to avatar_url
  end

  # shows logged in user artworks, actives goes in a grid with images
  # and inactives go on a list below
  # max var needs to be decimal to get right number os pages on division
  # mijnkunst = my art
  #
  def mijnkunst
    max = 20.0
    @currentpage = 0
    spage = 0
    if params[:page] && params[:page].to_i > 0
      spage = (params[:page].to_i * max).ceil
      @currentpage = params[:page].to_i
    end
    countarr = Kunstvoorwerp.count(:all,  
      :conditions => { active: true, user_id: @me.id }, 
      :include => [:kunstimage, :user], 
      :order => 'kunstvoorwerps.created_at DESC'
    )
    @kvs = Kunstvoorwerp.find(:all,  
      :conditions => { active: true, user_id: @me.id }, 
      :include => [:kunstimage, :user],
      :order => 'kunstvoorwerps.created_at DESC',
      :offset => spage,
      :limit => max
    )
    @pagecount = countarr / max
    @pagecount = @pagecount.ceil
    @kvi = Kunstvoorwerp.find(:all,  
      :conditions => { active: false, user_id: @me.id }, 
      :order => 'kunstvoorwerps.updated_at DESC'
    )
  end

  def n
    if !params[:id]
      return hit_error(404)
    end
    @user = User.find_by_id(params[:id])
    if !@user
      return hit_error(404)
    end
    if @user.can('xpose')
      redirect_to kunstenaar_url(:name => @user.intname)
    end  
  end
end
