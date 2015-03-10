require 'spec_helper'

describe Admin::NewsController do
  let(:user){ FactoryGirl.create(:confirmed_user) }
  let(:admin_role){ Role.create!(name: "admin") }
  describe "as a non logged user" do
    describe "trying to access" do
      it "can't access the index page" do
        get :index
        response.status.should == 403
      end
      it "can't access the new page" do
        get :new
        response.status.should == 403
      end
      it "can't access the create page" do
        post :create
        response.status.should == 403
      end
      it "can't access the edit page" do
        get :edit, id: "a"
        response.status.should == 403
      end
      it "can't access the update page" do
        put :update
        response.status.should == 403
      end
    end
  end
  describe "as a logged user but not a admin user" do
    before do
      sign_in user
    end
    describe "trying to access" do
      it "can't access the index page" do
        get :index
        response.status.should == 403
      end
      it "can't access the new page" do
        get :new
        response.status.should == 403
      end
      it "can't access the create page" do
        post :create
        response.status.should == 403
      end
      it "can't access the edit page" do
        get :edit, id: "a"
        response.status.should == 403
      end
      it "can't access the update page" do
        put :update
        response.status.should == 403
      end
    end
  end
  describe "as a logged admin user" do
    before do
      admin_role.permissions << Permission.create!(name: 'admin')
      user.role = admin_role
      user.save
      sign_in user
    end
    
    it "access the index page" do
      get :index
      response.should be_success
      assigns(:news).should == []
    end
    describe "creating a new news" do
      it "render the news form" do
        get :new
        response.should be_success
        assigns(:news).should be_new_record
      end
      it "should notice when the news was successfuly created" do
        News.any_instance.stub(:save){ true }
        post :create, news: {}
        flash[:notice].should_not be_nil
        response.should redirect_to(admin_news_index_path)
      end
      it "should render the new template when the news hasn't saved" do
        News.any_instance.stub(:save){ false }
        post :create, news: {}
        response.should render_template("new")
      end
    end
    
    describe "editing a news" do
      let(:news){ double("News") }
      
      before do
        News.stub(:find){ news }
      end
      
      it "renders de edit form" do
        get :edit, id: "a"
        assigns(:news).should == news
        response.should be_success
      end
    
      it "should notice when the news has sucessfuly saved" do
        news.stub(:update_attributes){ true }
        put :update, news: {}
        flash[:notice].should_not be_nil
        response.should redirect_to admin_news_index_path
      end
      
      it "should render the edit template when the news hasn't saved" do
        news.stub(:update_attributes){ false }
        put :update, news: {}
        response.should render_template("edit")
      end
    end
  end
end
