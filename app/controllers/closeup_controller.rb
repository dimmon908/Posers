class CloseupController < ApplicationController

  # Finds artwork and removes its closeup
  def destroy
    artwork = Kunstvoorwerp.find_by_id(params[:id])
    artwork.closeup.destroy
    artwork.closeup_id = nil
    artwork.save

    redirect_to werk_url(:name => artwork.user.intname, :kunstid => artwork.id)
  end
end
