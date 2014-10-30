class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    redirect_to root_url
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
			respond_to do |format|
				format.html { redirect_to(root_url,
					:notice => "Successfully update profile.") }
				format.xml  { head :ok }
			end
    else
      render :action => "edit"
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :password,
                                :password_confirmation)
  end
end
# vi:set ft=ruby ts=2 sw=2 ai:
