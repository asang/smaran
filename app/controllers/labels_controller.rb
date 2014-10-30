class LabelsController < ApplicationController
  before_filter :require_user
  before_action :set_label,
      only: [:edit, :update, :destroy]

  # GET /labels
  # GET /labels.xml
  def index
    @labels = Label.order(sort_column('Label') + ' ' + sort_direction)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @labels }
    end
  end

  # GET /labels/1
  # GET /labels/1.xml
  def show
    begin
      @label = Label.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @label = Label.find_by_name(params[:id]) if @label.nil?
    end
    respond_to do |format|
      format.html
      format.xml { render :xml => @label }
      format.pdf do
        pdf = AccountsPdf.new(@label.accounts,
                      "List of #{@label.description}")
        send_data pdf.render, type: "application/pdf",
                      disposition: "inline"
      end
    end
  end

  # GET /labels/new
  # GET /labels/new.xml
  def new
    @label = Label.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @label }
    end
  end

  # GET /labels/1/edit
  def edit
  end

  # POST /labels
  # POST /labels.xml
  def create
    @label = Label.new(params[:label])

    respond_to do |format|
      if @label.save
        format.html { redirect_to(@label, :notice => 'Label was successfully created.') }
        format.xml  { render :xml => @label, :status => :created, :location => @label }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @label.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /labels/1
  # PUT /labels/1.xml
  def update
    params[:label][:account_ids] ||= []
    respond_to do |format|
      if @label.update_attributes(params[:label])
        format.html { redirect_to(@label, :notice => 'Label was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @label.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /labels/1
  # DELETE /labels/1.xml
  def destroy
    respond_to do |format|
      if @label.destroy
        format.html { redirect_to(labels_url, :notice => "Label was removed") }
        format.xml  { head :ok }
      else
        format.html { render action: :show }
        format.xml  { render :xml => @label.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:account).permit(:account_id, :label_id)
  end

end
# vi:set et ft=ruby ts=2 sw=2 ai:
