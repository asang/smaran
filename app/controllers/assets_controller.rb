class AssetsController < ApplicationController
  before_filter :require_user
  def show
    asset = Asset.find(params[:id])
    send_file asset.data.path, :type => asset.data_content_type, :disposition => 'inline'
  end

  def destroy
    asset = Asset.find(params[:id])
    @account_id = asset.attachable.id
    asset.data = nil
    asset.save
    asset.destroy
    redirect_to account_path(Account.find(@account_id))
  end
end
# vi:set et ts=2 sw=2 ai ft=ruby:
