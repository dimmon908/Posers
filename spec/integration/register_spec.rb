#encoding: utf-8
require 'spec_helper'

feature "Register" do
  
  background do
    home_kunstvoorwerp
    visit '/'
  end
  
  scenario "Registering a new user" do
    click_on "aanmelden"
    fill_in "Gebruikersnaam", with: "felix"
    fill_in "E-mail adres", with: "felix@felix.com"
    fill_in "E-mail adres ter bevestiging", with: "felix@felix.com"
    fill_in "Wachtwoord", with: "teste123"
    fill_in "Wachtwoord ter bevestiging", with: "teste123"
    check "user_eula"
    click_on " Aanmelden >>"
    page.should have_content "Je bent inschreven. Toch konden we niet aanmelden omdat u in uw account is niet bevestigd."
    current_path.should == root_path
  end

end