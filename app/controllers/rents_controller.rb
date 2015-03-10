class RentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_artwork

  layout 'kunst'

  # Get content about rent process and show it to user
  #
  def new
    @page = Page.find_by_title('Huren bij Xposers')
  end

  # Register new rental and emails user
  #
  def create
    @rent = @artwork.rents.new
    if @rent.confirm(current_user)
      Kunstmail.rent(current_user, @artwork).deliver
      redirect_to root_url, notice: "Check your email for further instructions"
    end
  end

  private
    def set_artwork
      @artwork = Kunstvoorwerp.find(params[:artwork_id])
      redirect_to root_url, notice: "Artwork cant be hired" if @artwork.status > 0
    end
end
