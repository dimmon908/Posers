class Admin::RentsController < Admin::AdminController

  def index
    @rents = Rent.includes(:user, :kunstvoorwerp).paginate(:page => params[:page])
  end

  def show
    @rent = Rent.includes(:user, :kunstvoorwerp).find(params[:id])
  end

  # Change artwork status according to admins choice on show view
  #
  def update
    @rent = Rent.find(params[:id])

    if params[:rent][:delete]
      @rent.kunstvoorwerp.update_attribute('status', 0)
      @rent.delete
      redirect_to :action => 'index'
    else
      if params[:rent][:done]
        @rent.kunstvoorwerp.update_attribute('status', 2)
      end
      if params[:rent][:revert]
        @rent.kunstvoorwerp.update_attribute('status', 0)
      end
      @rent.status = params[:rent][:status]
      @rent.save
    end
  end

  # Render form with email content replaced by actual values from users
  # and artworks
  #
  def mailing
    @mail = Prefabmail.find(params[:mail][:message])
    @rent = Rent.find_by_id(params[:id])
    if params[:mail][:to] == "v"
      @email = @rent.kunstvoorwerp.user.email
    else
      @email = @rent.user.email
    end

    @mail.content = replace_prefab_mail_vars(@mail, @rent)
  end

  def send_email
   Kunstmail.transaction_mail(params[:prefabmail][:title],
                              params[:prefabmail][:from],
                              params[:prefabmail][:to],
                              params[:prefabmail][:content]).deliver
   flash[:notice] = 'Mail verzonden'
   redirect_to :action => 'show', :id => params[:id]
  end
end
