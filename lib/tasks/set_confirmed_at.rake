namespace :confirmable do
  desc "Set confirmed_at for users registered while Devise confirmable was off"
  task update: :environment do
    User.update_all ["confirmed_at = ?", Time.now], confirmed_at: nil
    if User.where(confirmed_at: nil).count == 0
      puts "All users confirmed" 
    else
      puts "Something went wrong. Check confirmed_at were not updated properly"
    end
  end
end
