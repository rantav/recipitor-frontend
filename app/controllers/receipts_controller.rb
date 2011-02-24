class ReceiptsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # GET /receipts
  # GET /receipts.xml
  def index
    @receipts =  Receipt.paginate :page => params[:page], :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @receipts }
    end
  end

  # GET /receipts/1
  # GET /receipts/1.xml
  def show
    @receipt = Receipt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @receipt }
    end
  end

  # GET /receipts/1/edit
  def edit
    @receipt = Receipt.find(params[:id])
  end

  # POST /receipts
  # POST /receipts.xml
  def create
    @user = User.find(params[:user_id])
    @receipt = @user.receipts.create(params[:receipt])
    render :json => {:pic_path => @receipt.img_url, :name => @receipt.img_file_name}
    #redirect_to user_path(@user) #TODO(ran): Use this redirect in some cases?
  end

  # PUT /receipts/1
  # PUT /receipts/1.xml
  def update
    @receipt = Receipt.find(params[:id])

    respond_to do |format|
      if @receipt.update_attributes(params[:receipt])
        format.html { redirect_to(@receipt, :notice => 'Receipt was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @receipt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.xml
  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy

    respond_to do |format|
      format.html { redirect_to(receipts_url) }
      format.xml  { head :ok }
    end
  end

  def view
    current_user = 'userit' ##TODO(ran): extract user from cookie
    head(:not_found) and return if (receipt = Receipt.find_by_id(params[:id])).nil?
    head(:forbidden) and return unless receipt.authorized?(current_user)

    style = params[:style]
    path = receipt.img.path(style)
    head(:bad_request) and return unless params[:extension].to_s == File.extname(path).gsub(/^\.+/, '')

    redirect_to(receipt.authenticated_url(style))
  end



  # display the users receipts
  # GET /receipts
  # GET /receipts.xml
  def mylist
	logger.debug "going to list all receipts for user #{current_user.email}"
    # @receipts =  Receipt.paginate :page => params[:page], :per_page => 10
    @user = current_user
    #@receipts =  Receipt.paginate :page => params[:page], :per_page => 4
    
     @receipts =  Receipt.paginate :per_page => 4, :page => params[:page], :conditions => ["user_id = #{current_user.id}"]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @receipts }
    end
  end
  
  
end
