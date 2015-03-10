require 'spec_helper'

feature "Admin Dashboard" do
  let(:user){ FactoryGirl.create(:confirmed_user) }
  let(:admin){ FactoryGirl.create(:admin) }
  
  background do
    user
    admin
    home_kunstvoorwerp
    visit '/'
    click_on "inloggen"
  end
  
  scenario "Could'nt see the admin option when is a normal user" do
    login as: user
    page.should have_content "Je bent succesvol ingelogd."
    page.should_not have_content "admin"
  end
  
  scenario "Accessing the admin dashboard" do
    login as: admin
    
    page.should have_content "Je bent succesvol ingelogd."
    page.should have_content "admin"
    
    click_on "admin"
    
    page.should have_content "Welkom bij de beheerspagina van xposers.nl"
    
  end
  
end