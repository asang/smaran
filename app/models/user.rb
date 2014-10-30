class User < ActiveRecord::Base
  acts_as_authentic
  validates :password, :presence => true
  attr_accessible :username, :email, :password, :password_confirmation
end
