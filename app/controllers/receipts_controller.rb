class ReceiptsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # display the users receipts
  # GET /receipts
  # GET /receipts.xml
  def index
    @user = current_user
    @receipts = get_paginated_receipts
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @receipts }
    end
  end

  # GET /receipts/1
  # GET /receipts/1.xml
  def show
    @receipt = Receipt.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @receipt }
    end
  end

  # GET /receipts/1/edit
  def edit
    @receipt = Receipt.find(params[:id])
  end

  # PUT /receipts/1
  # PUT /receipts/1.xml
  # PUT /receipts/1.json
  def update
    @receipt = Receipt.find(params[:id])
    respond_to do |format|
      if @receipt.update_attributes(params[:receipt])
        format.html { redirect_to receipt_after_update_path }
        format.xml { head :ok }
        format.json { render :json => {:status => :ok} }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @receipt.errors, :status => :unprocessable_entity }
        format.json { render :json => @receipt.errors, :status => :unprocessable_entity }
      end
    end
  end

  def view
    head(:not_found) and return if (receipt = Receipt.find_by_id(params[:id])).nil?
    head(:forbidden) and return unless receipt.authorized?(current_user)

    style = params[:style]
    path = receipt.img.path(style)
    head(:bad_request) and return unless params[:extension].to_s == File.extname(path).gsub(/^\.+/, '')

    redirect_to(receipt.authenticated_url(style))
  end
  
  # DELETE /receipts/1
  # DELETE /receipts/1.xml
  # DELETE /receipts/1.js
  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to(receipt_after_delete_path) }
      format.xml { head :ok }
      format.js
    end
  end
  
  def new
  end
  
  # POST /receipts
  # POST /receipts.xml
  # POST /receipts.json
  def create
    @user = User.find(params[:user_id])
    @receipt = @user.receipts.create(params[:receipt])
#YM: for extracting words using OCR script
#    logger.info("****\n****\nabout to extract words using ocr/go #{@receipt.img.path}");
#    tokens = %x("ocr/go" "#{@receipt.img.path}").split("\n")
#    logger.info("extracted tokens are #{tokens} ");    
#    @receipt.description=tokens;
#    @receipt.save;
    respond_to do |format|
      format.json { render :json => {
        :pic_path => @receipt.img_url,
        :name => @receipt.img_file_name,
        :id => @receipt.id,
        :authenticity_token => form_authenticity_token}}
      format.html {redirect_to user_path(@user)}
      format.xml {redirect_to user_path(@user)}
    end
  end

  protected

  def get_paginated_receipts
    @receipts = Receipt.paginate :order => 'id DESC', :per_page => 10, :page => params[:page], :conditions => ["user_id = #{current_user.id}"]
  end
  
  def receipt_after_update_path
    receipt_path(@receipt, :notice => 'Receipt was successfully updated.')
  end
  
  def receipt_after_delete_path
    receipts_url
  end
end
