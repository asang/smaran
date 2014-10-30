When(/^I fill in account details$/) do
  click_link_or_button 'New Account'
  fill_in_account_details(build_account)
  click_button 'Create Account'
end

Then(/^page should have notice message "(.*?)"$/) do |arg1|
  page.should have_content($1)
end

When(/^An account has been created$/) do
  @account = create_account
end

When(/^I delete the account$/) do
  @account.destroy
end
Then(/^page should have account name$/) do
  page.should have_content(@account.name)
end

When(/^I submit new log "([^"]*)"$/) do |log|
  fill_in 'comment_content', with: log
  click_link_or_button 'Add New Log'
  current_path.should == account_path(@account)
end

Then(/^page should have log "([^"]*)"$/) do |log|
  within('#logs') do
    page.should have_content(log)
  end
end

When(/^I delete the log entry$/) do
  within('#logs') do
    click_link_or_button 'Remove'
  end
end

Then(/^page should not have log entries$/) do
  page.should_not have_selector('#logs')
end

When(/^I submit new attachment "([^"]*)"$/) do |attachment|
  within('#add_attachment') do
    attach_file 'account_assets', "tmp/aruba/#{attachment}"
    click_link_or_button 'Submit'
  end
  @last_attachment_path = "#{Rails.root}/assets/docs/#{Asset.last.id}" \
                          "/original/#{Asset.last.name}"
end

When(/^I delete the attachment "(.*?)"$/) do |attachment_name|
  within('#attachments') do
    click_link_or_button 'Remove'
  end
end

Then(/^attachment "([^"]*)" contents should match$/) do |attachment|
  attachment_id = Asset.last.id
  attachment_path = "#{Rails.root}/assets/docs/#{attachment_id}/original/#{attachment}"
  src_file = "tmp/aruba/#{attachment}"
  check_file_presence([attachment_path], true)
  src_path = "#{Rails.root}/#{src_file}"
  check_file_content(attachment_path, IO.read(src_file), true)
end

Then(/^page should not have any attachments$/) do
  page.should_not have_selector('#attachments')
  check_file_presence([@last_attachment_path], false)
end

When(/^I add maximum attachments$/) do
  n = 0
  while n < @max_attachments do
    within('#add_attachment') do
      file_name = "attachment#{n}.txt"
      write_file(file_name, "This is a simple attachment")
      attach_file 'account_assets', "tmp/aruba/#{file_name}"
      click_link_or_button 'Submit'
    end
    n += 1
  end
end

Then(/^the page should have maximum attachments$/) do
  latest_assets = @account.assets
  within('#attachments') do
    n = 0
    Rails.logger.debug page.body
    Account.find(@account.id).assets.each do |a|
      should have_selector("#attachment_#{a.id}")
      n = n + 1
    end
    n.should == @max_attachments
  end
end

Given(/^I try to create maximum attachments$/) do
  @max_attachments = Account::Max_Attachments
end
