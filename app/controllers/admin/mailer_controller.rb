class Admin::MailerController < ApplicationController
  before_filter :require_admin
  layout 'admin'
  
  def index
    if request.post?
      params[:mail][:to].each do |m|
        mmail = Massmail.find(m)
        Kunstmail.massmail(mmail.title, mmail.user.email, mmail.message).deliver
        mmail.update_attribute(:sent, true)
      end
    end
    @mails = Massmail.paginate(:page => params[:page], :include => :user, :conditions => {:sent => false}, :per_page => 20)
  end
  def delete
    if params[:id]
      mmail = Massmail.find(params[:id])
      mmail.destroy
      redirect_to :action => 'index'
    else
      hit_error(404)
    end
  end
  def create
    if params[:nmail]
      
      uvb = User.find(:all, :conditions => {:receive_maillist => true})
      uvb.each do |u|
        Massmail.create(:user_id => u.id, :title => params[:nmail][:title], :message => params[:nmail][:message], :sent => false)
      end
    end
    redirect_to :action => 'index'
  end
  def deleteall
    Massmail.destroy_all
    redirect_to :action => 'index'
  end
end
