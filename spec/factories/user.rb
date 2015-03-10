FactoryGirl.define do
  factory :user do |f|
    f.email    'foo@bar.com'
    f.password 'teste123'
    f.password_confirmation 'teste123'
    f.nickname 'foobar'
    f.eula "yes"
  end

  factory :confirmed_user, :parent => :user do |f|
    f.after_create { |user| user.confirm! }
  end
  
  factory :admin, :parent => :confirmed_user do |f|
     f.email 'admin@bar.com'
     f.nickname 'admin'
     f.eula "yes"
     f.role { FactoryGirl.create(:admin_role) }
  end
  
end