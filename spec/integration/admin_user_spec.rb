require 'spec_helper'

feature "Admin User" do
  let(:user){ FactoryGirl.create(:confirmed_user) }
  let(:admin){ FactoryGirl.create(:admin) }
  
  background do
    user
    admin
    home_kunstvoorwerp
    visit '/'
    click_on "inloggen"
    login as: admin
    click_on "admin"
    click_on "Gebruikers"
  end
  
  scenario "viewing the user list" do
    page.should have_content "Gebruikers"
    page.should have_content user.nickname
    page.should have_content admin.nickname
  end
  
  scenario "editing a user" do
    click_on "wijzigen"  
    fill_in "user_nickname", with: "WOOW"
    click_on "Wijzig deze gebruiker"
    page.should have_content "WOOW"
  end
  
  scenario "removing a user" do
    within("##{user.id}") do
      click_on "verwijderen"
    end
    click_on "Verwijder"
    page.should_not have_content user.nickname
    page.should have_content admin.nickname
  end
  
  scenario "Exporting a csv with the users" do
    click_on "Publiceer leden in CSV"
    page.should have_content user.nickname
    page.should have_content admin.nickname
  end
  
  scenario "Viewing the role list" do
    click_on "Groepen"
    page.should have_content "admin"
  end
  
  scenario "Creating a new role" do
    click_on "Groepen"
    fill_in "role_name", with: "lol"
    click_on "Create new role"
    page.should have_content "lol"
  end
  
  scenario "Viewing a role" do
    click_on "Groepen"
    click_on "admin"
    page.should have_content("admin")
    page.should have_content("delete")
  end
  
  scenario "Add permissions to a role" do
    click_on "Groepen"
    click_on "admin"
    fill_in "permission_name", with: "lol"
    click_on "Toevoegen"
    page.should have_content("lol")
  end
  
  scenario "Removing a permission from a role" do
    click_on "Groepen"
    click_on "admin"
    
    fill_in "permission_name", with: "lol"
    click_on "Toevoegen"
    page.should have_content("lol")
    
    within("#p#{Permission.last.id}") do
      click_on "delete"
    end
    click_on "Yes, delete it!"
    page.should_not have_content("lol")
  end
  
end