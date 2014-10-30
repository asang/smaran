class AccountMailer < ActionMailer::Base
  default :from => APP_CONFIG['password_to']
  def send_by_email(account, to)
    @account = account
    mail(:to => to, :subject => "Account details for #{account.name}")
  end
end
# vi:set et ts=2 sw=2 ai ft=ruby:
