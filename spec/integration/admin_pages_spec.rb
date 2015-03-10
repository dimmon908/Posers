require 'spec_helper'

feature "Admin Pages" do
  let(:user){ FactoryGirl.create(:confirmed_user) }
  let(:admin){ FactoryGirl.create(:admin) }
  let(:content){ FactoryGirl.create(:page) }
  
  background do
    admin
    content
    home_kunstvoorwerp
    
    visit '/'
    click_on "inloggen"
    login as: admin
    click_on "admin"
    click_on "Teksten"
  end
  
  scenario "Viewing a list of the pages" do
    page.should have_content content.title
  end
  
  scenario "Creating a new page" do
    click_on "Nieuwe page"
    fill_in "page_title", with: "Another Page"
    fill_in "page_content", with: "A Great content"
    click_on "Create"
    page.should have_content "Another Page"
  end
  
  scenario "Editing a page" do
    click_on "Wijzigen"
    fill_in "page_title", with: "Another Page"
    click_on "Update"
    page.should have_content "Another Page"
  end
  
  scenario "Viewing a page" do
    click_on content.title
    page.should have_content content.title
  end
  
  scenario "Removing a page" do
    click_on "Verwijderen"
    page.should_not have_content content.title
  end
  
end