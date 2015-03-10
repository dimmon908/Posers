class Admin::PrefabmailController < ApplicationController
  before_filter :require_admin
  layout 'admin'
  def index
    @pms = Prefabmail.find(:all)
    @mail = Prefabmail.new
  end
  def create
    @mail = Prefabmail.new(params[:prefabmail])
    if @mail.save
      flash[:notice] = 'Prefabmail opgeslagen.'
      redirect_to(:action => 'edit', :id => @mail.id) 
    else
      render :action => "index"
    end
  end
  def edit
    @mail = Prefabmail.find(params[:id])
    if request.post? || request.put?
      @mail.update_attributes(params[:prefabmail])
    end
  end
  def delete
    @mail = Prefabmail.find(params[:id])
    @mail.destroy
    redirect_to :action => 'index'
  end
  def intmails
    @ims = Intmail.find(:all)
  end
  def editintmail
    @mail = Intmail.find(params[:id])
    if request.post? || request.put?
      flash[:notice] = 'Interne mail gewijzigd.'
      @mail.update_attributes(params[:intmail])
      redirect_to :action => 'intmails'
      
    end
  end
end
