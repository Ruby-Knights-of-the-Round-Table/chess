FactoryGirl.define do
  factory :player do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end

  factory :game do
    game_name "Test Game"
  end
end
