class ConfirmationsController < Devise::ConfirmationsController

  # override Devise after confirmation path so that
  # user go to homepage after clicking confirmation link
  #
  def after_confirmation_path_for(resource_name, resource)
    root_url
  end
end
