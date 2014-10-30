# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/rails'
require 'factory_girl_rails'
require 'authlogic/test_case'
require 'aruba/api'
require 'aruba/cucumber'

include Authlogic::TestCase
activate_authlogic

module LoginHelpers
  def create_user
    FactoryGirl.create(:user)
  end

  def fill_in_user_pass(user)
    fill_in 'user_session_username', with: user.username
    fill_in 'user_session_password', with: user.password
    click_button 'Submit'
  end

  def change_user_passwd(passwd)
    fill_in 'user_password', with: passwd
    fill_in 'user_password_confirmation', with: passwd
  end
end

module AccountHelpers
  def build_account
    FactoryGirl.build(:account)
  end

  def create_account
    FactoryGirl.create(:account)
  end

  def fill_in_account_details(account, attachment = nil)
    click_link_or_button 'New Account'
    fill_in 'account_name', with: account.name
    fill_in 'account_url', with: account.url
    fill_in 'account_username', with: account.url
    fill_in 'account_password', with: account.password
    fill_in 'account_password_confirmation', with: account.password
    fill_in 'account_comments', with: account.comments
    if not attachment.nil?
      attach_file 'account_assets', "#{attachment}"
    end
  end
end

module LabelHelpers
  def create_label
    FactoryGirl.create(:label)
  end

  def fill_in_label_details(label)
    click_link_or_button 'New Label'
    fill_in 'label_name', with: label.name
    fill_in 'label_description', with: label.description
  end
end

World(LoginHelpers)
World(AccountHelpers)
World(LabelHelpers)
