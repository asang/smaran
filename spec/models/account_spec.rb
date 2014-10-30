# vim: set et ts=2 sw=2 et:
require 'spec_helper'

describe 'Account' do
  let(:account) { FactoryGirl.build(:account) }
  subject { account }

  before(:each) do
    PaperTrail.enabled = true
  end

  it { should respond_to(:name) }
  it { should respond_to(:username) }
  it { should respond_to(:url) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:encrypted_url) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:encrypted_comments) }
  it { should respond_to(:versions) }

  describe "Validations" do
    describe "name" do
      it "is required" do
        account.name = nil
        expect(account).to_not be_valid
        expect(account).to have(2).error_on(:name)
        expect(account.errors_on(:name)).to include( 'is invalid' )
        expect(account.errors_on(:name)).to include( 'can\'t be blank' )
      end
      it "name should valid" do
        names = [ '/', '^name' ]
        names.each do |invalid_name|
          account.name = invalid_name
          expect(account).to_not be_valid
          expect(account).to have(1).error_on(:name)
          expect(account.errors_on(:name)).to include('is invalid')
        end
      end
      it "should be unique" do
        account.save
        account2 = FactoryGirl.build(:account)
        account2.name = account.name
        expect { account2.save! }.to raise_error(ActiveRecord::RecordInvalid, /taken/)
      end
      it "is encrypted/decrypted correctly" do
        name = 'nmfoo'
        account.name = name
        account.save!
        expect(account.name).to eql(name.upcase)
      end
    end

    describe "username" do
      it "is required" do
        account.username = nil
        expect(account).not_to be_valid
        expect(account).to have(1).error_on(:username)
        expect(account.errors_on(:username)).to include('can\'t be blank')
      end
      it "is encrypted/decrypted correctly" do
        username = 'unfoo'
        account.username = username
        account.save!
        expect(account.username).to eql(username)
      end
    end
    describe "url" do
      it "is required" do
        account.url = nil
        expect(account).to_not be_valid
        expect(account).to have(2).error_on(:url)
        expect(account.errors_on(:url)).to include('can\'t be blank')
        expect(account.errors_on(:url)).to include('is invalid')
      end
      it "is incorrect" do
        invalid_urls = [ 'urls', 'ftp://' ]
        invalid_urls.each do |u|
          account.url = u
          expect(account).to_not be_valid
          expect(account).to have(1).error_on(:url)
          expect(account.errors_on(:url)).to include('is invalid')
        end
      end
      it "is encrypted/decrypted correctly" do
        valid_urls = [ 'http://', 'https://', 'https://example.com',
                        'http://example.com/' ]
        valid_urls.each do |u|
          account.url = u
          expect(account).to be_valid
          expect(account.url).to eql(u)
        end
      end
    end
    describe "password" do
      it "is required" do
        account.password = nil
        expect(account).to_not be_valid
        expect(account).to have(1).error_on(:password)
        expect(account.errors_on(:password)).to include('can\'t be blank')
      end

      it "doesn't match" do
        account.password_confirmation = 'abc'
        expect(account).to_not be_valid
        expect(account).to have(1).error_on(:password_confirmation)
        expect(account.errors_on(:password_confirmation)).to \
                        include("doesn't match Password")
      end
      it "matches confirmation" do
        expect(account).to be_valid
      end
      it "is encrypted/decrypted correctly" do
        passwd = 'shhhhh'
        account.password, account.password_confirmation = passwd, passwd
        account.save!
        expect(account.password).to eql(passwd)
      end
    end
    describe "comments" do
      it "can be blank or anything else" do
        [ nil, '', 'anything', 'asasda989893232!#2777' ].each do |c|
          account.comments = c
          expect(account).to be_valid
          expect(account.comments).to eql(c)
        end
      end
    end
  end
  describe "Change" do
    describe "Undo" do
      it "create" do
        account = FactoryGirl.build(:account)
        expect { account.save }.to change(Account, :count).by(1)
        expect { account.versions.last.item.destroy }.to \
                  change(Account, :count).by(-1)
      end
      it "delete" do
        account = FactoryGirl.build(:account)
        expect { account.save }.to change(Account, :count).by(1)
        expect { account.reload.destroy }.to change(Account, :count).by(-1)
        v = PaperTrail::Version.find account.versions.last.id
        expect { v.reify.save! }.to change(Account, :count).by(1)
      end
      it "update" do
        account = FactoryGirl.build(:account)
        expect { account.save! }.to change(Account, :count).by(1)
        old_obj = account.clone
        account.update_attributes( username: "username #{account.id}" )
        v = PaperTrail::Version.find account.reload.versions.last.id
        v.reify.save!
        expect(account.reload).to eql(old_obj)
      end
    end
  end
end
