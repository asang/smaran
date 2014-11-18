# vim: set et ts=2 sw=2 et:
require 'spec_helper'

describe 'Account Requests', :type => :feature do
  include UserHelper
  let(:account) { FactoryGirl.build(:account) }
  let(:user) { create_user }

  before(:each) do
    PaperTrail.enabled = true
  end

  it 'display root path' do
    do_login
    expect(page).to have_content('Successfully logged in')
    visit root_url
    expect(current_path).to eq(root_path)
    visit accounts_path
    expect(current_path).to eq(accounts_path)
    expect(page).to have_content('List of Accounts')
  end

  it 'should fail to create empty account' do
    do_login
    visit root_url
    click_link_or_button 'New Account'
    expect(current_path).to eq(new_account_path)
    click_button 'Create Account'
    expect(current_path).to eq(accounts_path)
    expect(page).to have_content('can\'t be blank')
  end

  it 'should create new account' do
    do_login
    visit root_url
    click_link_or_button 'New Account'
    fill_account_details
    click_button 'Create Account'
    expect(page).to have_content('Account was successfully created.')
    expect(current_path).to eq(account_path(Account.last))
  end

  it 'should create account with labels' do
    label1 = create_label
    label2 = create_label
    create_new_account(attachment=nil, labels=[label1.id, label2.id])
    expect(page).to have_content('Account was successfully created.')
    expect(page).to have_content("#{label1.description}")
    expect(page).to have_content("#{label2.description}")
    Rails.logger.debug('Detach a label')
    click_link_or_button 'Edit'
    find(:css, "#account_label_ids_[value='#{label1.id}']").set(false)
    click_link_or_button 'Update Account'
    expect(page).to have_content('Account was successfully updated')
    within('#labels') do
      expect(page).to_not have_content("#{label1.description}")
      expect(page).to have_content("#{label2.description}")
    end
  end

  it 'should create new account with attachment' do
    create_new_account(attachment='attachment.txt')
    expect(page).to have_content('Account was successfully created.')
    attachment_id = Account.last.assets.last.id
    attachment_path = "#{Rails.root}/assets/docs/" +
        "#{attachment_id}/original/attachment.txt"
    assert File.exists?(attachment_path)
    expect(current_path).to eq(account_path(Account.last))
    expect(page).to have_content('attachment.txt')
    src_file = "#{Rails.root}/test/fixtures/attachment.txt"
    assert FileUtils::identical?(src_file, attachment_path)
  end

  it 'should delete attachment' do
    create_new_account(attachment='attachment.txt')
    attachment_id = Account.last.assets.last.id
    attachment_path = "#{Rails.root}/assets/docs/" +
        "#{attachment_id}/original/attachment.txt"
    within('#attachments') do
      click_link_or_button 'Remove'
    end
    expect(page).to_not have_content('attachment.txt')
    expect(page).to_not have_selector('#attachments')
    assert !File.exists?(attachment_path)
  end

  it 'should undo and redo delete' do
    Account.destroy_all
    account.save!
    do_login
    visit accounts_path
    click_link_or_button 'Remove'
    expect(page).to have_content('Account was deleted')
    expect(page).to_not have_content(account.name.upcase)
    click_link_or_button 'undo'
    expect(page).to have_content('Undid destroy')
    expect(page).to have_content(account.name.upcase)
    click_link_or_button 'redo'
    expect(page).to have_content('Undid create')
    expect(page).to_not have_content(account.name.upcase)
  end

  it 'should undo and redo update' do
    Account.destroy_all
    account.save!
    do_login
    visit accounts_path
    click_link_or_button 'Edit'
    new_name = "new #{account.name}"
    fill_in 'account_name', with: new_name
    click_link_or_button 'Update Account'
    expect(page).to have_content('Account was successfully updated')
    expect(page).to have_content(new_name.upcase)
    click_link_or_button 'undo'
    expect(page).to have_content('Undid update')
    expect(page).to have_content(account.name.upcase)
    expect(page).to_not have_content(new_name.upcase)
    click_link_or_button 'redo'
    expect(page).to have_content('Undid update')
    expect(page).to have_content("Details for #{new_name.upcase}")
  end

  it 'should undo and redo create' do
    do_login
    Account.destroy_all
    create_new_account
    click_link_or_button 'undo'
    expect(current_path).to eq(accounts_path)
    expect(page).to have_content('Undid create')
    expect(page).to_not have_content(account.name.upcase)
    click_link_or_button 'redo'
    expect(page).to have_content('Undid destroy')
    expect(page).to have_content(account.name.upcase)
  end

  describe 'Edit' do
    before(:each) do
      do_login
      Account.destroy_all
      account.save!
      visit account_path(account)
    end
    it 'should allow editing' do
      new_name = "NEW_#{account.name}"
      new_url = FactoryGirl.build(:account).url
      visit account_path(account)

      click_link 'Edit'
      fill_in 'account_name', with: new_name
      fill_in 'account_url', with: new_url
      click_button 'Update Account'
      account.name = new_name
      expect(current_path).to eq(account_path(account))
      expect(page).to have_content('Account was successfully updated')
      expect(page).to have_content(new_name)
      expect(page).to have_content(new_url)
    end
    it 'should change password when confirmation matches' do
      newpass = 'newpass123'
      click_link 'Edit'
      fill_in 'account_password', with: newpass
      fill_in 'account_password_confirmation', with: newpass
      click_button 'Update Account'
      expect(current_path).to eq(account_path(account))
      expect(page).to have_content('Account was successfully updated')
      expect(Account.find(account.id).password).to eql(newpass)
    end

    it 'should not change password when confirmation doesn\'t match' do
      newpass = 'newpass123'
      old_pass = account.password
      click_link 'Edit'
      fill_in 'account_password', with: newpass
      fill_in 'account_password_confirmation', with: 'foo'
      click_button 'Update Account'
      expect(current_path).to eq(account_path(account))
      expect(page).to have_content('doesn\'t match Password')
      expect(Account.find(account.id).password).to eql(old_pass)
    end

    def do_duplicate
      click_link 'Duplicate'
      fill_in 'account_username', with: "#{account.username}"
      fill_in 'account_password', with: 'pass123'
      fill_in 'account_password_confirmation', with: 'pass123'
      click_button 'Create Account'
      expect(page).to have_content('Account was successfully created')
      expect(current_path).to eq(account_path(account.id + 1))
    end
    it "should duplicate account" do
      do_duplicate
    end
  end

  describe 'search' do
    it 'by name should work' do
      a1, a2 = FactoryGirl.build(:account), FactoryGirl.build(:account)
      a1.name, a2.name = "abc", "def"
      a1.save!
      a2.save!
      do_login
      visit accounts_path
      expect(page).to have_content( a1.name.upcase )
      expect(page).to have_content( a2.name.upcase )
      fill_in 'search', with: 'Nothing'
      click_button 'Search'
      expect(current_path).to eq(accounts_path)
      expect(page).to_not have_content( a1.name.upcase )
      expect(page).to_not have_content( a2.name.upcase )
      fill_in 'search', with: a1.name
      click_button 'Search'
      expect(page).to have_content( a1.name.upcase )
      expect(page).to_not have_content( a2.name.upcase )
      fill_in 'search', with: a2.name
      click_button 'Search'
      expect(page).to_not have_content( a1.name.upcase )
      expect(page).to have_content( a2.name.upcase )
    end
  end
end
# vi:set et ts=2 sw=2 ft=ruby ai:
