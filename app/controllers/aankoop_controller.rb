class AankoopController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_artwork

  layout 'wide'
  
  # Find the Artwork
  # Check if it isnt already bought or reserved
  #
  def set_artwork
    @kunstvoorwerp = Kunstvoorwerp.find(params[:id])

    @aankoop = Aankoop.find_by_kunstvoorwerp_id(@kunstvoorwerp.id)
    if !@aankoop.blank?
      flash[:notice] = 'Je hebt dit voorwerp al gekocht.'
      redirect_to werk_url(:name => @kunstvoorwerp.user.intname, :kunstid => @kunstvoorwerp.id) and return
    end

    if @kunstvoorwerp.status != 0
      flash[:notice] = 'Dit voorwerp is al verkocht of gereserveerd.'
      redirect_to werk_url(:name => @kunstvoorwerp.user.intname, :kunstid => @kunstvoorwerp.id)
    end
  end

  def index
  end

  # Shows form to complete the order
  #
  def order
  end

  # Register order
  # Send email to user who ordered and another email to site admins
  #
  def confirm

    if current_user.update_attributes(params[:user])
      
      aankoop = Aankoop.confirm(current_user, @kunstvoorwerp)
      if aankoop

        mail = Intmail.find_by_inttitle('koop_koper')
        if !mail.blank?
          nmail = mail.message
          nmail = nmail.gsub(/<k_username>/, current_user.nickname)
          nmail = nmail.gsub(/<k_voornaam>/, current_user.voornaam)
          nmail = nmail.gsub(/<k_achternaam>/, current_user.achternaam)
          nmail = nmail.gsub(/<kv_title>/, @kunstvoorwerp.title)
          nmail = nmail.gsub(/<kv_url>/, url_for(werk_url(:name => @kunstvoorwerp.user.intname, :kunstid => @kunstvoorwerp.id)))
          nmail = nmail.gsub(/<kv_id>/, aankoop.id.to_s)
          Kunstmail.massmail(mail.title, current_user.email, nmail).deliver
        else
          aankoop.delete
          @kunstvoorwerp.update_attribute('status', 0)
          return hit_error 500
        end

        # stuurt mail naar eigenaar site
        Kunstmail.koop_beheer(@kunstvoorwerp,
                              current_user,
                              aankoop.id,
                              url_for(werk_url(:name => @kunstvoorwerp.user.intname, :kunstid => @kunstvoorwerp.id)),
                              url_for(aankoop_url(:id => aankoop.id)),
                              @kunstvoorwerp.verzendmethode).deliver

        redirect_to done_aankoop_url(aankoop)
      end
    else
      render :order
    end
  end

  # Shows message telling order was completed successfully
  #
  def done
    @aankoop = Aankoop.find(params[:id])
  end
end
