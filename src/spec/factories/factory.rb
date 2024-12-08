FactoryBot.define do
  
  factory :admin, class: User do
    email { 'admin@example.com' }
    password { 'password'}
    admin { true }
  end

  factory :user do
    email { 'user@example.com' }
    password { 'password'}
  end

  factory :user2, class: User do
    email { 'user2@example.com' }
    password { 'password' }
  end

  factory :company, class: User do
    email { 'company@example.com'}
    password { 'password'}
    company { true }
  end

  factory :skill do
    sequence(:title) { |n| "Skill #{n}" }
  end

end