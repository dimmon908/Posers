class Admin::PagesController < ApplicationController
  before_filter :require_admin
  layout 'admin'

  def index
    @pages = Page.find(:all)
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      flash[:notice] = 'Page was successfully created.'
      redirect_to(:action => 'show', :id => @page.id) 
    else
      render :action => "new"
    end
  end

  def update
    @page = Page.find(params[:id])
    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(:action => 'show', :id => @page.id) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to(:action => 'index')
  end
end
