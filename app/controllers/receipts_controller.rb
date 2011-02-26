class ReceiptsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # display the users receipts
  # GET /receipts
  # GET /receipts.xml
  def index
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
 # GET /receipts/1
  # GET /receipts/1.xml
  def show
    @receipt = Receipt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @receipt }
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
  
  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy

    respond_to do |format|
      format.html { redirect_to(receipts_url) }
      format.xml  { head :ok }
    end
  end
  
  def new 
	logger.debug "current_user is #{current_user.email}"
  end
  
    # POST /receipts
  # POST /receipts.xml
  def create
    @user = User.find(params[:user_id])
    @receipt = @user.receipts.create(params[:receipt])
    render :json => {:pic_path => @receipt.img_url, :name => @receipt.img_file_name}
    #redirect_to user_path(@user) #TODO(ran): Use this redirect in some cases?
  end

end
