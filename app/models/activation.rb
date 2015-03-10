class Activation < ActionMailer::Base
  def registration(username, useremail, actlink, boardemail, unid, sent_at = Time.now)
    subject    '[xposers] Welkom ' + username + ' bij Xposers'
    recipients useremail
    from       boardemail
    sent_on    sent_at

    body['username'] = username
    body['unid'] = unid
    body['actlink'] = actlink
  end
  def passwordlost(username, useremail, reclink, boardemail, unid, sent_at = Time.now)
    subject    '[xposers] Xposers wachtwoord'
    recipients useremail
    from       boardemail
    sent_on    sent_at

    body['username'] = username
    body['unid'] = unid
    body['reclink'] = reclink
  end
end
