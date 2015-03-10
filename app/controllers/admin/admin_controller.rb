class Admin::AdminController < ApplicationController
  before_filter :require_admin
  layout 'admin'

  # Used both on Aankopen and Verhuren admin section
  # Receives and email instance from Prefabmail model and
  # another instance from either Aankopen or Rend model
  #
  def replace_prefab_mail_vars(mail, model)
   # algemeen
   mail.content = mail.content.gsub(/<prijs>/, model.prijs.to_s)
   mail.content = mail.content.gsub(/<titel>/, sanitize_text(model.kunstvoorwerp.title))
   mail.content = mail.content.gsub(/<linknaarobject>/, werk_url(:name => model.kunstvoorwerp.user.intname, :kunstid => model.kunstvoorwerp.id))
   mail.content = mail.content.gsub(/<kv_id>/, model.id.to_s)
   
   # koper
   mail.content = mail.content.gsub(/<k_voornaam>/, sanitize_text(model.user.voornaam))
   mail.content = mail.content.gsub(/<k_achternaam>/, sanitize_text(model.user.achternaam))
   mail.content = mail.content.gsub(/<k_adres>/, sanitize_text(model.user.prive_adres))
   mail.content = mail.content.gsub(/<k_postcode>/, sanitize_text(model.user.prive_postcode))
   mail.content = mail.content.gsub(/<k_woonplaats>/, sanitize_text(model.user.prive_woonplaats))
   
   # verkoper     
   mail.content = mail.content.gsub(/<v_voornaam>/, sanitize_text(model.kunstvoorwerp.user.voornaam))
   mail.content = mail.content.gsub(/<v_achternaam>/, sanitize_text(model.kunstvoorwerp.user.achternaam))
   mail.content = mail.content.gsub(/<v_adres>/, sanitize_text(model.kunstvoorwerp.user.prive_adres))
   mail.content = mail.content.gsub(/<v_postcode>/, sanitize_text(model.kunstvoorwerp.user.prive_postcode))
   mail.content = mail.content.gsub(/<v_woonplaats>/, sanitize_text(model.kunstvoorwerp.user.prive_woonplaats))
   mail.content = mail.content.gsub(/<v_bankrekening>/, sanitize_text(model.kunstvoorwerp.user.prive_bankrek))
  end
end
