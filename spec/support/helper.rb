def login(options={})
  email = options[:as].email
  password = options[:password] || "teste123"
  fill_in "user_nickname", with: email
  fill_in "user_password", with: password
  click_on "Login!"
end