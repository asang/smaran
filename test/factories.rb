FactoryGirl.define do
  factory :account do |f|
    f.sequence(:name) { |n| "Foo#{n}" }
    f.sequence(:username) { |n| "foo#{n}" }
    f.sequence(:url)    { |n| "http://foo#{n}.example.com/" }
    f.password            "foobar123"
    f.password_confirmation { |u| u.password }
    f.sequence(:comments) { |n| "Comments for foo#{n}" }
  end

  factory :user do |f|
    f.sequence(:username) { |n| "foo#{n}" }
    f.sequence(:email)    { |n| "foo#{n}@example.com" }
    f.password            "foobar123"
    f.password_confirmation { |u| u.password }
  end

  factory :label do |f|
    f.sequence(:name) { |n| "Label foo#{n}" }
    f.sequence(:description) { |n| "description #{n}" }
  end

  factory :comment do |f|
    f.sequence(:content) { |c| "Comment #{c}" }
  end
end
