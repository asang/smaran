require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "should not create account without name" do
    account = Account.new
    assert !account.save
  end

  test "should not create account without password" do
    account = Account.create :name => 'HDFC',
                             :url => 'http://goo.gl',
                             :username => 'kset'
    assert !account.save
  end

  test "should create account" do
    attrs = FactoryGirl.attributes_for(:account)
    account = Account.create attrs
    assert account.save
    assert account.comments == attrs[:comments]
    assert account.password == attrs[:password]
    assert account.url == attrs[:url]
  end

  test "should not create account with invalid url" do
    attrs = FactoryGirl.attributes_for(:account)
    attrs.merge!(url: "invalid")
    account = Account.create attrs
    assert !account.save
  end

  test "should not create account with passwd mismatch" do
    attrs = FactoryGirl.attributes_for(:account)
    attrs.merge!(password_confirmation: "invalid")
    account = Account.create attrs
    assert !account.save
  end
end