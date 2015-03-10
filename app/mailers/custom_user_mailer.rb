class CustomUserMailer < Devise::Mailer

  # Overides devise method to add custom subjects
  # and bcc mail
  #
  def headers_for(action)
    headers = {
     :subject       => find_custom_subject(action),
     :from          => mailer_sender(devise_mapping),
     :to            => resource.email,
     :bcc           => "info@xposers.nl",
     :template_path => template_paths
    }
  end

  # Looks for custom title on database according to the action
  #
  def find_custom_subject(action)
    if action =~ /confirmation/
      Intmail.find_by_id(2).title
    elsif action =~ /password/
      Intmail.find_by_id(3).title
    else
      translate(devise_mapping, action)
    end
  end
end
