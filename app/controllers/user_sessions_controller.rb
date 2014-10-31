class UserSessionsController < ApplicationController
  include UserSessionsHelper
  def new
    @user_session = UserSession.new
    logger.debug("Remote IP is #{request.remote_ip}") if is_local_client
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    logger.debug("Remote IP is #{request.remote_ip}") if is_local_client
    if not is_local_client and
        verify_recaptcha(request.remote_ip, params)[:status] == 'false'
      @notice = "captcha incorrect"
      respond_to do |format|
        format.html { render :action => "new", :notice => flash[:alert] }
        format.xml  { render :xml => @user_session.errors,
              :status => :unprocessable_entity }
      end
    else
      if @user_session.save
        flash[:notice] = "Successfully logged in."
        redirect_to root_url
      else
        render :action => 'new'
      end
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy if not @user_session.nil?
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end
# vi:set ft=ruby ts=2 sw=2 ai:
