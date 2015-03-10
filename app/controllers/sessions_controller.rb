class SessionsController < Devise::SessionsController
  def create
    begin
      user = User.find_for_database_authentication(params[:user])
      if user && user.encrypted_password.nil?
        user.send_reset_password_instructions
        redirect_to root_path, notice: "Sorry, door ons nieuwe systeem moet je jouw wachtwoord opnieuw instellen. Kijk in je mailbox voor de link."
        return
      end
    rescue ActiveRecord::RecordNotFound
      # let devise to do that
    end
    super
  end
end
