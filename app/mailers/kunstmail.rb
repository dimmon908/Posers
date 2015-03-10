class Kunstmail < ActionMailer::Base
  default from: "no-reply@xposers.nl"
  
  # Used when user order artwork
  # Doubt this one is still useful, may be removed later
  #
  def koop_beheer(object, profile, orderid, ourl, aurl, verzendmethode, sent_at = Time.now)
    @name = "#{profile.voornaam} #{profile.achternaam}"
    @adres = "#{profile.prive_adres},  #{profile.prive_postcode} #{profile.prive_woonplaats}"
    @telefoon = profile.prive_telefoonnummer
    @prijs = object.prijs
    @orderid = orderid
    @verzendmethode = verzendmethode
    @object_url = ourl
    @admin_url = aurl
    mail(to: %w{rene@xposers.nl jasper@xposers.nl}, subject: "[xposers: aankoop] #{object.title}")
  end
  
  # Used admin wants to email directly users who bought or rent an artwork
  #
  def transaction_mail(title, from, to, content, sent_at = Time.now)
    @msg = content
    mail(to: to, bcc: 'info@xposers.nl', subject: title)
  end
  
  # Mail sent when user comment on an artwork (kunstvoorwerp)
  #
  def reactiemail(comment_author, artwork, bericht, link, sent_at = Time.now)
    @comment_author, @artwork, @comment, @link = comment_author, artwork, bericht, link

    @mail_content = Intmail.find_by_id(4)
    mail(to: artwork.user.email,
         bcc: 'info@xposers.nl',
         subject: "[xposers] Reactie op #{artwork.title} van #{comment_author.voornaam}" )
  end
  
  # Used when ordering artwork (aankoop) and on gebruiker controllers
  #
  def massmail(title, email, bericht, sent_at = Time.now)
    @bericht = bericht
    mail(to: email, bcc: 'info@xposers.nl', subject: title)
  end
  
  # mail when a user wants to indicate an artwork to another user
  # params - artwork title, artwork url, receiver name,
  # receiver email, message, sender user
  #
  def tellafriend (titel, werkurl, naam, email, bericht, sender, sent_at = Time.now)
    @artwork_title, @artwork_url, @message, @receiver, @sender = titel, werkurl, bericht, naam, sender

    @mail_content = Intmail.find_by_id(5)
    subject = @mail_content.title.sub('<sender_username>', "#{sender.voornaam} #{sender.achternaam}")
    mail(to: email, bcc: 'info@xposers.nl', subject: subject)
  end
  
  def reactieedit (email, name, message, objecturl, sent_at = Time.now)
    @name = name
    @objecturl  = objecturl
    @message  = message
    mail(to: email, bcc: 'info@xposers.nl', subject: "[xposers] Bericht van beheer" )
  end

  # Email sent when a user confirm artwork rent to the user who rent it
  #
  def rent(user, artwork)
    @user, @artwork  = user, artwork
    subject = "Huur van <name of work> via Xposers".sub('<name of work>', artwork.title)

    @mail_content = Intmail.find_by_id(6)
    mail(to: user.email, bcc: 'info@xposers.nl', subject: subject)
  end
end
