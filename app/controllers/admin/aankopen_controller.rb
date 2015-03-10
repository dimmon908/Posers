class Admin::AankopenController < Admin::AdminController

  def index
    @aankopen = Aankoop.paginate(:page => params[:page], :order => 'updated_at DESC', :include => [{:kunstvoorwerp => :user}, :user])
  end

  def view
    if !params[:id]
      hit_error 404
    end
    @aankoop = Aankoop.find_by_id(params[:id])
    if @aankoop.blank?
      hit_error 404
    end
    if request.post?
      if params[:aankoop][:delete]
        @aankoop.kunstvoorwerp.update_attribute('status', 0)
        @aankoop.delete
        redirect_to :action => 'index'
      else
        if params[:aankoop][:done]
          @aankoop.kunstvoorwerp.update_attribute('status', 2)
        end
        if params[:aankoop][:revert]
          @aankoop.kunstvoorwerp.update_attribute('status', 0)
        end
        @aankoop.status = params[:aankoop][:status]
        @aankoop.save
      end
    end
  end

 def mailing
   @mail = Prefabmail.find(params[:mail][:message])
   @aankoop = Aankoop.find_by_id(params[:id])
   if params[:mail][:to] == "v"
     @email = @aankoop.kunstvoorwerp.user.email
   else
     @email = @aankoop.user.email
   end

   @mail.content = replace_prefab_mail_vars(@mail, @aankoop)
 end

 def sendmail
   Kunstmail.transaction_mail(params[:mail][:title], params[:mail][:from], params[:mail][:to], params[:mail][:content]).deliver
   flash[:notice] = 'Mail verzonden'
   redirect_to :action => 'view', :id => params[:id]
 end 
end
