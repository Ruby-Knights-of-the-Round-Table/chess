FactoryGirl.define do
  factory :move do
    piece_id 1
    turn 1
    x 1
    y 1
  end
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
