# to handle 404 errors
class CustomNotFoundError < StandardError
  # nothing here
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout 'normal'
  #protect_from_forgery # :secret => '4ad6af810dfgdfg0260ad711'
  # rescue_from ActiveRecord::RecordNotFound, with: :hit_404
  
  before_filter :check_user, :setup_search
  before_filter :find_page_for_agenda
  before_filter :store_location

  def store_location
    session[:user_return_to] = request.url unless params[:controller] == "sessions"
  end

  def after_sign_in_path(resource)
    stored_location_for(resource) || root_path
  end

  @artperpage = 9

  def rescue_404
    rescue_action_in_public CustomNotFoundError.new
  end

  # Tries to find page named Agenda and link it on the site menu
  def find_page_for_agenda
    @page_for_agenda = Page.where(title: "Agenda").order("id DESC").first
  end

  def rescue_action_in_public(exception)
    case exception
    when CustomNotFoundError, ::ActionController::UnknownAction then
      redirect_to(root_path)
      #render :template => "shared/error", :layout => "application", :status => "404"
    else
      @message = exception
      render :template => "shared/error", :layout => nil, :status => "500"
    end
  end    

  def setup_search
    if request.env["HTTP_HOST"] == "xposers.com" or request.env["HTTP_HOST"] == "xposers.com:80"
      redirect_to "http://www.xposers.nl" + request.env["PATH_INFO"]
    end
  
    #@type = Type.joins(:propertycontainers => :kunstproperties).uniq!
    @type = Type.all
    @type2 = []
    @type3 = []
    @type.each do |t|
      if t.dimensie == 2
        @type2.push t
      else
        @type3.push t  
      end
    end
    
    if params[:p1] and !params[:p1].blank?
      @prijs1 = params[:p1]
    else
      @prijs1 = 'van'
    end
    if params[:p2] and !params[:p2].blank?
      @prijs2 = params[:p2]
    else
      @prijs2 = 'tot'
    end
    # formaat
    # breedte
    if params[:fb1] and !params[:fb1].blank?
      @formaatb1 = params[:f1]
    else
      @formaatb1 = 'van'
    end
    if params[:fb2] and !params[:f2].blank?
      @formaatb2 = params[:fb2]
    else
      @formaatb2 = 'van'
    end
    #hoogte 
    if params[:fh1] and !params[:fh1].blank?
      @formaath1 = params[:f1]
    else
      @formaath1 = 'van'
    end
    if params[:fh2] and !params[:fh2].blank?
      @formaath2 = params[:fh2]
    else
      @formaath2 = 'van'
    end
    if params[:q]
      @qopdracht = params[:q]
    else
      @qopdracht = ''
    end
    
  end




  protected
  #
  # check user, required to be done all the time
  #
  def check_user
    
    if user_signed_in?
      # session exists, user needs to be found
      
      begin
        @me = current_user
        @logged_in = true
      rescue ActiveRecord::RecordNotFound
        session[:user_id] = nil
        @logged_in = false
        redirect_to root_url
        return nil
      end
      
      # user has no role, first time log in
      if @me.role.blank?
        r = Role.find_by_name('user')
        if r.blank?
          r = Role.new(:name => 'user')
          @me.role = r
        else
          @me.role = r
        end
        @me.save
      end
       
      
      
      if @me.isrole('banned')
        @logged_in = false
        @me = User.new({:nickname => 'guest'})
        role = Role.find_by_name('guest')
        if role.blank?
          role = Role.create({:name => 'guest'})
        end
        @me.role = role
        flash[:notice] = 'Je account is gebanned.'
        session[:user_id] = 0
        cookies[:xposerslogin] = {
          :value => '',
          :expires => 1.year.from_now,
        }
      end
      
     
    else
      # no session, new login. or not logged in
      if cookies[:xposerslogin] and !cookies[:xposerslogin].blank?
        # cookie with long term session exists
        linsess = LoginSession.find_by_authentication_key(cookies[:xposerslogin])
        if !linsess.blank?
          # result = positive
          session[:user_id] = linsess.user_id
          @me = User.find(session[:user_id])
          flash[:notice] = 'Welkom terug op xposers.nl'
          @logged_in = true
          
          if @me.isrole('banned')
            # user still can be bannned, so, check that.
            @logged_in = false
            @me = User.new({:nickname => 'guest'})
            # assign guest role
            role = Role.find_by_name('guest')
            if role.blank?
              role = Role.create({:name => 'guest'})
            end
            @me.role = role
            flash[:notice] = 'Je account is gebanned.'
            session[:user_id] = nil
            cookies[:xposerslogin] = {
              :value => '',
              :expires => 1.year.from_now,
            }
          end
          
        end
      else
        @logged_in = false
        @me = User.new({:nickname => 'guest'})
        role = Role.find_by_name('guest')
        if role.blank?
          role = Role.create({:name => 'guest'})
        end
        @me.role = role
      end
    end
  end
  # ferret stuff
  def pages_ferret_for(size, options = {})
    default_options = {:per_page => 10}
    options = default_options.merge options
    pages = Paginator.new self, size, options[:per_page], (params[:page]||1)
    return pages
  end


  def is_a_number?(s)
  s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  #
  # errrororoorror
  #
  def hit_error (mode)
    #render :file => "#{Rails.root}/public/" + mode.to_s + ".html", :status => mode and return
    render :template => "shared/error", :layout => nil, :status => mode
  end
  protected
  
  def hit_404
    hit_error(404)
  end
  
  def forum_permissions
    if !@me.blank?
    @me.role.get_forum_permissions
    end
  end

  # used when getting text from form inputs for example
  def sanitize_text (text)
    return ERB::Util.html_escape(text)
  end

  def sanitize_int (inttosanitize)
    inttosanitize.to_s
    inttosanitize.sub(/[^0-9]/, '')
    return inttosanitize
  end
  
  def require_admin
    return hit_error(403) if !user_signed_in?
    if !current_user.can('admin')
      return hit_error(403)
    end
  end
  
end
