module KunstmailHelper

  include KunstennarHelper

  # Receives the intmail instance and replace vars for respective values
  # current used vars are: 
  #   logged in user info 
  #   receiver name
  #   sender complete name
  #   artwork url
  #   message send by the user
  #
  def replace_tellafriend_vars sender, intmail, artwork_url, receiver, user_message
    sender = "#{sender.voornaam} #{sender.tussenvoegsel} #{sender.achternaam}"

    message = intmail.message.sub('<receiver_username>', receiver)
    message = message.sub('<sender_username>', sender)
    message = message.sub('<message>', user_message)
    message = message.sub('<link>', artwork_url)

    simple_format message
  end

  
  # Receives the intmail instance and replace vars for respective values
  # current used vars are: 
  #   artwork author object
  #   comment sent by user
  #   link to artwork
  #
  def replace_reactiemail_vars(intmail, artwork, comment, link, author)
    owner_name = "#{artwork.user.voornaam} #{artwork.user.tussenvoegsel} #{artwork.user.achternaam}"

    message = intmail.message.sub('<username>', owner_name)
    message = message.sub('<reactie>', comment)
    message = message.sub('<link>', link)
    message = message.sub('<artwork_name>', artwork.title)
    message = message.sub('<sender_name>', author.voornaam)

    simple_format message
  end

  # Receives intmail, user who wants to rent and artwork instances
  #
  def replace_rent_vars intmail, user, artwork
    artwork_owner = "#{artwork.user.voornaam} #{artwork.user.tussenvoegsel} #{artwork.user.achternaam}" 

    message = intmail.message.sub('<username-first>', user.voornaam)
    message = message.sub('<name of work>', artwork.title)
    message = message.sub('<full name of artist, first-, mid- and last name.>', artwork_owner)
    message = message.sub('<price>', rent_price(artwork.prijs))
    message = message.sub('<verzendkosten>', shipping_info(artwork.verzendmethode))

    simple_format message
  end

end
