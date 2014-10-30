Given(/^a valid user exists$/) do
  @user = create_user
end

Given(/^I fill in login credentials$/) do
  fill_in_user_pass(create_user)
end

Given(/^I am logged in as valid user$/) do
  @user = create_user
  visit new_user_session_url
  fill_in_user_pass(@user)
end

When(/^I fill in invalid username$/) do
  fill_in 'user_session_username', with: 'invalid'
  fill_in 'user_session_password', with: 'don\'t care'
  click_button 'Submit'
end

When(/^I fill in invalid password$/) do
  fill_in 'user_session_username', with: @user.username
  fill_in 'user_session_password', with: 'wrong'
  click_button 'Submit'
end

When(/^I change the password to "([^"]*)"$/) do |passwd|
  click_link_or_button 'Change Password'
  change_user_passwd(passwd)
  fill_in 'user_password', with: passwd
  fill_in 'user_password_confirmation', with: passwd
  click_link_or_button 'Submit'
end

When(/^I should be able to relogin with new password$/) do
  click_link_or_button 'Logout'
  page.should have_selector('#user_session_username')
  fill_in 'user_session_username', with: @user.username
  fill_in 'user_session_password', with: @user.password
  click_link_or_button 'Submit'
  page.should have_content('Successfully logged in')
end
