# vim: set et ts=2 sw=2 et:
require 'spec_helper'

describe User do
  include UserHelper
  let(:user) { create_user }
  subject { user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  
  describe "don't authenticate with wrong password" do
    it { should_not be_valid_password('wrongpass') }
  end

  describe "authenticate with correct password" do
    before { user.update_attributes(password: 'foobar',
              password_confirmation: 'foobar' ) }
    it { should be_valid_password('foobar') }
  end

  describe "when username is not present" do
    before { user.username = '' }
    it { should_not be_valid }
  end

  describe "Passsword change" do
    describe "when password is not confirmed" do
      before { user.password, user.password_confirmation ='abcd', '' }
      it { should_not be_valid }
    end
    describe "password is too short" do
      before { user.password, user.password_confirmation = 'abc', 'abc' }
      it { should_not be_valid }
    end

    describe "password change is confirmed" do
      before { user.password, user.password_confirmation = 'abcd', 'abcd' }
      it { should be_valid }
    end

    describe "password is changed - crypt should change" do
      before do
        @old_crypted_password = user.crypted_password
        user.password, user.password_confirmation = 'foob', 'foob'
      end
      it { should be_valid }
      it "should not match old crypt" do
        expect(user.crypted_password).to_not eql(@old_crypted_password)
      end
    end
  end
end
