class AccountsController < ApplicationController
  before_filter :require_user
  before_action :set_account,
    only: [:send_by_email, :show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.xml
  def index
    order_by = sort_column('Account') + ' ' + sort_direction
    @accounts = Account.search(params[:search], params[:page], order_by)
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :layout => false } # index.js.erb
      format.xml  { render :xml => @accounts }
      format.csv { send_data Account.to_csv(Account.order('name')) }
      format.xls {
        buffer = Account.to_xls(Account.order('name'))
        send_data buffer, :filename => "accounts.xls"
      }
      format.pdf do
        pdf = AccountsPdf.new(Account.order('name'))
        send_data pdf.render, type: "application/pdf",
            disposition: "inline"
      end
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    begin
      @account = Account.find(params[:id])
      @commentable = @account
      @comments = @account.logs.reverse
      @comment = Comment.new
    rescue ActiveRecord::RecordNotFound
      redirect_to accounts_url
      return
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
      format.pdf do
        pdf = AccountPdf.new(@account)
        send_data pdf.render, type: "application/pdf",
            disposition: "inline"
      end
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account.password_confirmation = @account.password
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])
    process_file_uploads(@account)

    respond_to do |format|
      if @account.save
        format.html { redirect_to(@account,
                          notice: "Account was successfully created. #{undo_link}") }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    params[:account][:label_ids] ||= []
    process_file_uploads(@account)
    respond_to do |format|
      if @account.update_attributes(account_params)
        format.html { redirect_to(@account,
                            notice: "Account was successfully updated. #{undo_link}") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url,
                      notice: "Account was deleted #{undo_link}") }
      format.xml  { head :ok }
    end
  end

  #
  # Duplicate an existing account with all it's attributes
  # GET /accounts/1/duplicate
  def duplicate
    @account = Account.find(params[:id]).dup
    @account.name += ' - NEW'
    @account.username = ''
    @account.password = ''
  end

  #
  # Send account details by email
  # GET /accounts/1/send
  def send_by_email
    AccountMailer.send_by_email(@account, APP_CONFIG['password_to']).deliver
    respond_to do |format|
      format.html { redirect_to(@account,
          :notice => "Successfully sent email to #{APP_CONFIG['password_to']}") }
    end
  end
  #
  # Sets/clears For Your eyes only flag
  # GET /accounts/for_your_eyes
  def hide_passwords
    if params[:hide_passwords]
      session[:hide_passwords] = true
    else
      session[:hide_passwords] = false
    end
    redirect_to request.referrer
  end

  protected

  def process_file_uploads(account)
    unless params[:account][:assets].nil?
      account.assets.build(:data => params[:account][:assets])
    end
  end

  private

  def undo_link
    if not @account.versions.load.last.nil?
      view_context.link_to(:undo,
                revert_version_path(@account.versions.load.last.id),
                method: :post)
    end
  end

  def set_account
    begin
      @account = Account.find(params[:id])
    rescue
      @account = nil
    end
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true)
  end

  def account_params
    params.require(:account).permit(:name, :url, :username, :comments,
                                :versions, :password, :password_confirmation,
                                :updated_at, label_ids: [] )
  end

end
# vi:set et ft=ruby ts=2 sw=2 ai:
