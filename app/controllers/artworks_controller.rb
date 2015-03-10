class ArtworksController < ApplicationController
  before_filter :authenticate_user!, except: :verras_me
  before_filter :can_xpose?, except: :verras_me
  layout 'wide'

  def new
    @artwork = Kunstvoorwerp.new
    @title = 'Exposeren'
  end

  def create
    @artwork = current_user.kunstvoorwerps.new(params[:kunstvoorwerp])
    @artwork.sfield = @artwork.title + " " + @artwork.description + " " + @artwork.tags

    if @artwork.save
      @artwork.type.propertycontainers.each do |c|
        a = 'c' + c.id.to_s
        if params[:properties][a]
          @artwork.kprops.create(:kunstproperty_id => params[:properties][a])
        end
      end
    
      @artwork.kunstproperties.each do |kp|
        @artwork.sfield = @artwork.sfield + kp.title
      end
      
      if @artwork.sfield and @me.voornaam and @me.achternaam
        @artwork.sfield = @artwork.sfield + " " + @me.voornaam + " " + @me.achternaam
        @artwork.sfield.strip
      end

      if @artwork.save
        flash[:notice] = "Object succesvol geplaatst. "
        redirect_to plaatsafbeelding_url(@artwork.id)
      end
    else
      render :new
    end
  end

  # List random artworks. Verras me = surprise me
  #
  def verras_me
    @artworks = Kunstvoorwerp.random
  end

  private

    def can_xpose?
      redirect_to omzetten_url unless current_user.can('xpose')
    end

end
