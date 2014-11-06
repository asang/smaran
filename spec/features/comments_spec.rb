# vim: set et ts=2 sw=2 et:
require 'spec_helper'

describe Comment, :type => :feature do
  include UserHelper
  let(:account) { FactoryGirl.build(:account) }
  let(:comment) { FactoryGirl.build(:comment) }
  let(:user) { create_user }

  def create_account
    do_login
    account.save
    visit account_path(account)
  end

  before(:each) do
    create_account
  end

  def add_comment
    expect(page).to have_content(account.name)
    fill_in 'comment_content', with: comment.content
    click_link_or_button 'New Log'
    expect(page).to have_content(comment.content)
    expect(page).to have_content('Log created')
  end

  it 'should fail to create empty comment' do
    expect(page).to have_content(account.name)
    click_link_or_button 'New Log'
    expect(page).to have_content('Content can\'t be blank')
  end

  it 'should be able to add comment' do
    add_comment
  end

  it 'should be able to delete single comment' do
    add_comment
    visit account_path(account)
    within('#logs') do
      click_link_or_button 'Remove'
    end
    expect(page).to have_content('Log was deleted')
  end
end
