class Admin::KunstController < ApplicationController
  before_filter :require_admin
  layout 'admin'
  def index
    @types = Type.find(:all)
    @tweedee = []
    @driedee = []
    @types.each do |t|
      if t.dimensie == 2
        @tweedee.push t
      else
        @driedee.push t
      end
    end
    if request.post?
      if !params[:type][:title].blank?
        Type.create(:title => params[:type][:title], :dimensie => params[:type][:dimensie])
      end
      redirect_to :action => 'index'
    end
  end
  def show
    @types = Type.find(:all)
    @type = Type.find(params[:id])
  end
  def deleteproperty
    kp = Kunstproperty.find(params[:id])
    pid = kp.propertycontainer.type_id
    kp.destroy
    redirect_to :action => 'show', :id => pid
  end
  def deletecontainer
    kc = Propertycontainer.find(params[:id])
    pid = kc.type_id
    kc.kunstproperties.destroy_all
    kc.destroy
    redirect_to :action => 'show', :id => pid
  end
  def createcontainer
    if params[:id] and params[:container][:title] and !params[:container][:title].blank?
      pc = Propertycontainer.create(:title => params[:container][:title], :type_id => params[:id])
    else
      flash[:notice] = 'Titel is leeg'
    end
    redirect_to :action => 'show', :id => params[:id] 
  end
  def createproperty
    if params[:id] and params[:property][:title] and !params[:property][:title].blank?
      kc = Propertycontainer.find(params[:id])
      kc.kunstproperties.create(:title => params[:property][:title])
    else
      flash[:notice] = 'Titel is leeg'
    end
    redirect_to :action => 'show', :id => kc.type_id 
  end
  def editcontainer
    @container = Propertycontainer.find(params[:id])
    if request.post?
      if !params[:container][:title].blank?
        @container.update_attribute(:title, params[:container][:title])
        redirect_to :action => 'show', :id => @container.type_id
      end
    end
  end
  def editproperty
    @property = Kunstproperty.find(params[:id])
    if request.post?
      if !params[:property][:title].blank?
        @property.update_attribute(:title, params[:property][:title])
        redirect_to :action => 'show', :id => @property.propertycontainer.type_id
      end
    end
  end
  def edittype
    @type = Type.find(params[:id])
    if request.post? || request.put?
      @type.update_attributes(params[:type])
      redirect_to :action => 'index'
    end
  end
  def deletetype
    @type = Type.find(params[:id])
    @type.propertycontainers.destroy_all
    @type.destroy
    redirect_to :action => 'index'
  end
end
