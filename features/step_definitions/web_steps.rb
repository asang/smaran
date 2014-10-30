Given(/^(?:I )am on the (.+)$/) do |page_name|
  visit path_to(page_name)
end

Then /^(?:|I )should be on the (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    expect(current_path).to eql(path_to(page_name))
  else
    assert_equal path_to(page_name), current_path
  end
end

def do_match(content, parent, negate)
  if parent
    id = "##{parent}"
    within(id) do
      if negate
        page.should_not have_content("#{content}")
      else
        expect(page).to have_content("#{content}")
      end
    end
  else
    if negate
      expect(page).to_not have_content("#{content}")
    else
      expect(page).to have_content("#{content}")
    end
  end
end

Then /^page should have content "(.+)" within "(.+)"$/ do |content, parent|
  do_match(content, parent, false)
end

Then /^page should not have content "(.+)" within "(.+)"$/ do |content, parent|
  do_match(content, parent, true)
end
