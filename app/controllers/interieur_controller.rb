class InterieurController < ApplicationController
  layout 'kunst'
  def index
    
  end

  def upload
    if !@logged_in
      return hit_error(403)
    end
    if @me.interieurs.size > 9
      redirect_to :action => 'index'
      flash[:notice] = "Je kunt niet meer dan 10 persoonlijke interieurs hebben."
      return nil
    end
    if request.post? and params[:interieur]
      @interieur = Interieur.new params[:interieur]
      if @interieur.valid?

        @interieur.user_id = @me.id
        @interieur.save
        #if params[:kv][:kid]      
          #redirect_to :controller => 'kunst', :action => 'interieur', :id => params[:kv][:kid], :kid => @interieur.id
        #else
          redirect_to :action => 'index'
          flash[:notice] = 'Persoonlijke interieur geplaatst.'
        #end

      end
    end
  end
  def verwijder
    if @logged_in and params[:id]
      @interieur = Interieur.find_by_id(params[:id], :conditions => 'user_id = ' + @me.id.to_s)
      if @interieur.blank?
        return hit_error(404)
      end
      
      if request.post?
        @interieur.delete
        flash[:notice] = 'Interieur succesvol verwijderd.'
        redirect_to :action => 'index'
      end
      
    end
  end
end
