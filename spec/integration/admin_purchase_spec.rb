require 'spec_helper'

feature "Admin Purchases" do
  let(:user){ FactoryGirl.create(:confirmed_user, voornaam: "Rafael", achternaam: "Felix", intname: "felix") }
  let(:admin){ FactoryGirl.create(:admin) }
  let(:kv){ FactoryGirl.create(:kunstvoorwerp, user_id: user.id) }
  let(:purchase){ FactoryGirl.create(:aankoop, user_id: user.id, kunstvoorwerp_id: kv.id) }
  
  background do
    admin
    home_kunstvoorwerp
    
    purchase
    
    visit '/'
    click_on "inloggen"
    login as: admin
    click_on "admin"
    click_on "Aankopen"
  end
  
  scenario "Viewing the purchases" do
    page.should have_content user.voornaam
    page.should have_content purchase.status
  end
end