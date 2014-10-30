require 'net/http'

class ApplicationController < ActionController::Base
  protect_from_forgery unless Rails.env == 'test'
  helper_method :current_user, :sort_column, :sort_direction

  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def sort_direction
    %w[ASC DESC].include?(params[:direction]) ? params[:direction].upcase : "desc".upcase
  end

  def sort_column(m)
    klass = m.constantize
    cn = klass.column_names
    cn.include?(params[:sort]) ? params[:sort] : "updated_at"
  end

  protected

  # try and verify the captcha response. Then give out a message to flash
  def verify_recaptcha(remote_ip, params)
    responce = Net::HTTP.post_form(
      URI.parse('http://www.google.com/recaptcha/api/verify'),
      {'privatekey' => APP_CONFIG['recaptcha_private_key'],
        'remoteip' => remote_ip,
        'challenge' => params[:recaptcha_challenge_field],
        'response'=> params[:recaptcha_response_field]})
    result = {:status => responce.body.split("\n")[0],
      :error_code => responce.body.split("\n")[1]}
    if result[:error_code] == "incorrect-captcha-sol"
      flash[:alert] = "The CAPTCHA solution was incorrect. Please re-try"
    elsif
      flash[:alert] = <<-EOF
        There has been a unexpected error with the application.
        Please contact the administrator. error code: #{result[:error_code]}
      EOF
    end
    result
  end
end
