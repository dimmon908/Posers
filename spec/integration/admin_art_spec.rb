require 'spec_helper'

feature "Admin Art" do
  let(:user){ FactoryGirl.create(:confirmed_user) }
  let(:admin){ FactoryGirl.create(:admin) }
  let(:type){ FactoryGirl.create(:type) }
  
  background do
    admin
    type
    home_kunstvoorwerp
    visit '/'
    click_on "inloggen"
    login as: admin
    click_on "admin"
    click_on "Kunst"
  end
  
  scenario "Viewing the type list" do
    page.should have_content type.title
  end
  
  scenario "Editing a type" do
    click_on "wijzigen"
    fill_in "type_title", with: "Fotografias"
    click_on "Update Type"
    page.should have_content "Fotografias"
  end
  
  scenario "Removing a type" do
    click_on "verwijderen"
    page.should_not have_content type.title
  end
  
  scenario "Adding a new type" do
    fill_in "type_title", with: "LOOL"
    click_on "Submit Type"
    page.should have_content "LOOL"
  end
  
  scenario "Viewing the arts related to a type" do
    click_on type.title
    page.should have_content "Type: #{type.title}"
  end
  
  scenario "Creating a new container" do
    click_on type.title
    fill_in "container_title", with: "LOL"
    click_on "Toevoegen"
    page.should have_content "LOL"
  end
  
  scenario "Editing a container" do
    click_on type.title
    fill_in "container_title", with: "LOL"
    click_on "Toevoegen"
    click_on "wijzigen"
    fill_in "container_title", with: "TESTE"
    click_on "Wijzigen"
    page.should have_content "TESTE"
  end
  
  scenario "Removing a container" do
    click_on type.title
    fill_in "container_title", with: "LOL"
    click_on "Toevoegen"
    click_on "verwijderen"
    page.should_not have_content "LOL"
  end
  
  scenario "Creating a property" do
    click_on type.title
    fill_in "container_title", with: "LOL"
    click_on "Toevoegen"
    fill_in "property_title", with: "prop"
    click_on "Toevoegen"
    page.should have_content "prop"
  end
  
  scenario "Editing a property" do
    click_on type.title
    fill_in "container_title", with: "LOL"
    click_on "Toevoegen"
    fill_in "property_title", with: "prop"
    click_on "Toevoegen"
    within("#p#{Kunstproperty.last.id}") do
      click_on "wijzigen"
    end
    fill_in "property_title", with: "aprop"
    click_on "Wijzigen"
    page.should have_content "aprop"
  end
  
  scenario "Removing a property" do
    click_on type.title
    fill_in "container_title", with: "LOL"
    click_on "Toevoegen"
    fill_in "property_title", with: "prop"
    click_on "Toevoegen"
    within("#p#{Kunstproperty.last.id}") do
      click_on "Verwijderen"
    end
    page.should_not have_content "prop"
  end
end