FactoryGirl.define do
  factory :kunstvoorwerp do |f|
    f.title 'WOW'
    f.description 'Helo World'
    f.active true
    f.type { Factory.create(:type) }
    f.prijs 80
    f.height 20
    f.width 20
  end
end