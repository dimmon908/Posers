class TellafriendController < ApplicationController
  layout 'wide'

  def index

    if cookies[:mailed]
      flash[:notice] = 'Om spam te voorkomen is het niet mogelijk om meer dan 1 e-mail per 2 minuten te versturen.'
      if params[:id]
        @kv = Kunstvoorwerp.find(params[:id])
        redirect_to werk_url(:kunstid => @kv.id, :name => @kv.user.intname) 
      end
    end

    @kv = Kunstvoorwerp.find(params[:id])

    if request.post? and @logged_in
      if !params[:mail][:message].blank? and params[:mail][:email].gsub(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, '')

        if Kunstmail.tellafriend(@kv.title,
                                 werk_url(:kunstid => @kv.id, :name => @kv.user.intname),
                                 params[:mail][:name],
                                 params[:mail][:email],
                                 params[:mail][:message], current_user).deliver
          flash[:notice] = 'Je bericht is verzonden'
          cookies[:mailed] = {
            :value => 'yep',
            :expires => 2.minutes.from_now,
          }
          redirect_to werk_url(:kunstid => @kv.id, :name => @kv.user.intname)
        end
      else
        flash[:notice] = 'Je bericht kon niet verzonden worden, het e-mail adres is niet juist of het bericht is leeg.'
      end

    end
  end

end
