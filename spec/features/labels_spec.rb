# vim: set et ts=2 sw=2 et:
require 'spec_helper'

describe Label, :type => :feature do
  include UserHelper
  let(:label) { FactoryGirl.build(:label) }
  let(:user) { create_user }

  def add_label
    do_login
    visit root_url
    click_link_or_button 'New Label'
    expect(current_path).to eq(new_label_path)
    fill_in 'label_name', with: label.name
    fill_in 'label_description', with: label.description
    click_button 'Create Label'
    expect(page).to have_content('Label was successfully created')
    expect(current_path).to eq(label_path(Label.last))
  end

  it 'should fail to create empty label' do
    do_login
    visit root_url
    click_link_or_button 'New Label'
    expect(current_path).to eq(new_label_path)
    click_button 'Create Label'
    expect(current_path).to eq(labels_path)
    expect(page).to have_content('2 errors prohibited this label from being saved')
  end

  it 'should create a new label' do
    add_label
  end

  it 'should remove a new label' do
    add_label
    click_link_or_button 'Remove'
    expect(page).to have_content('Label was removed')
    expect(current_path).to eq(labels_path)
  end

  it 'should redirect to labels path' do
    add_label
    visit '/labels/2'
    expect(current_path).to eq(labels_path)
  end
end
