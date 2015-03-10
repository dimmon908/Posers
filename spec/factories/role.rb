FactoryGirl.define do
  factory :role do
    name "Guest"
  end
  factory :admin_role, :parent => :role do
    name "admin"
    after_create do |role|
      role.permissions << Factory.create(:permission, name: "admin")
    end
  end
end