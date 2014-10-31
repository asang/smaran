# vim: set et ts=2 sw=2 et:
require 'spec_helper'

describe Label, :type => :feature do
  include UserHelper
  let(:label) { FactoryGirl.build(:label) }
  let(:user) { create_user }

  it 'should fail to create empty label' do
    do_login
    visit root_url
    click_link_or_button 'New Label'
    expect(current_path).to eq(new_label_path)
    click_button 'Create Label'
    expect(current_path).to eq(labels_path)
    expect(page).to have_content('2 errors prohibited this label from being saved')
  end
end
