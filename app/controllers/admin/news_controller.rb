class Admin::NewsController < ApplicationController
  before_filter :require_admin
  layout 'admin'
  
  def index
    @title = 'Nieuws'
    @news = News.order("id desc").paginate :page => params[:page], :per_page => 50
  end
  
  def new
    @news = News.new
  end
  
  def create
    @news = News.new(params[:news].merge(:user_id => current_user.id))
    if @news.save
      redirect_to admin_news_index_path, notice: "Nieuws gemaakt"
    else
      render :new
    end
  end
  
  def edit
    @news = News.find(params[:id])
  end
  
  def update
    @news = News.find(params[:id])
    if @news.update_attributes(params[:news])
      redirect_to admin_news_index_path, notice: "Nieuws bijgewerkt"
    else
      render :edit
    end
  end
end
