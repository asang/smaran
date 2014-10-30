Given(/^New label is "([^"]*)" with description "([^"]*)"$/) do |l, d|
  @label = Label.new(name: l, description: d)
end

When(/^I create the label$/) do
  fill_in_label_details(@label)
  click_link_or_button 'Create Label'
end

Then(/^I should see the "([^"]*)"$/) do |result|
  if result == '+'
    within('#main') do
      page.should have_content('Label was successfully created')
      page.should have_content("#{@label.name.downcase}")
      page.should have_content("#{@label.description}")
    end
  else
    within('#main') do
      page.should_not have_content("#{@label.name.downcase}")
    end
  end
end

When(/^A label has been created$/) do
  @label = create_label
end

When(/^Label was mapped to the account$/) do
  @account.labels << @label
end

When(/^I am on labels page$/) do
  visit labels_path
end

When(/^I delete the label$/) do
  within('#main') do
    within('#item-list') do
      click_link_or_button 'Remove'
    end
  end
end