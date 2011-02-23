class EmailsController < ApplicationController

  # POST /receipts
  # POST /receipts.xml
  def create_old
  	puts "***************EmailsController::create creating new receipt from email #{params[:a]} __"  
  	params.keys.each { |k| puts "[#{k}]==>[#{params[k]}]" }
    @receipt = Receipt.new(params[:receipt])

	puts "@receipt.save == #{@receipt.save} "
    respond_to do |format|
      if @receipt.save
        format.html { redirect_to(@receipt, :notice => 'Receipt was successfully created.') }
        format.xml  { render :xml => @receipt, :status => :created, :location => @receipt }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @receipt.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
   # POST /receipts
  # POST /receipts.xml
  def create
  	puts "EmailsController::create"
  	params.keys.each { |k| puts "[#{k}]==>[#{params[k]}]" if (k != :img )  }
	if params[:secret].nil? || params[:secret].eql?  "kabal0t_4_the_wor1d"
		puts "secret is incorrct of does not exist"
	else
		@user = User.find_by_email(params[:user_email])
		puts "looking for user with email #{params[:user_email]} found user \n #{@user}"
		if (@user.nil?)
			return 
		end
		@receipt = @user.receipts.create(params[:receipt])
		#redirect_to user_path(@user)
	end
  end
  
end
