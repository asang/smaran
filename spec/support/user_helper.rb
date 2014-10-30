module UserHelper
  def create_user
    FactoryGirl.create(:user)
  end

  def create_label
    FactoryGirl.create(:label)
  end

  def do_login
    visit new_user_session_path
    fill_in 'user_session_username', with: user.username
    fill_in 'user_session_password', with: user.password
    click_button 'Submit'
  end

  def fill_account_details(attachment=nil, labels=nil)
    fill_in 'account_name', with: account.name
    fill_in 'account_url', with: account.url
    fill_in 'account_username', with: account.url
    fill_in 'account_password', with: account.password
    fill_in 'account_password_confirmation', with: account.password
    fill_in 'account_comments', with: account.comments
    if not attachment.nil?
      attach_file 'account_assets', "#{Rails.root}/test/fixtures/#{attachment}"
    end
    if not labels.nil?
      labels.each do |l|
        find(:css, "#account_label_ids_[value='#{l}']").set(true)
      end
    end
  end

  def create_new_account(attachment=nil, labels=nil)
    do_login
    visit root_path
    click_link_or_button 'New Account'
    fill_account_details(attachment, labels)
    expect(current_path).to eq(new_account_path)
    click_button 'Create Account'
  end
end
