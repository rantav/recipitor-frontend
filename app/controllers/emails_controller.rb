class EmailsController < ApplicationController
  
   # POST /receipts
  # POST /receipts.xml
  def create
  	logger.debug "The object is EmailsController::create"
  	params.keys.each { |k| logger.debug "[#{k}]==>[#{params[k]}]" if (k != :img )  }
  	apikey = ERB.new(YAML.load_file("#{RAILS_ROOT}/config/api.yml")[RAILS_ENV]["apikey"]).result
  	logger.debug  "validating [#{params['apikey']}] with [#{apikey}]"
	if params["apikey"].nil? || !(params["apikey"].eql?(apikey))
		logger.debug "apikey is incorrct or missing"
	else
		logger.debug "apikey matches"
		@user = User.find_by_email(params[:user_email])
		logger.debug "looking for user with email #{params[:user_email]} found user \n #{@user}"
		if (@user.nil?)
			return 
		end
		@receipt = @user.receipts.create(params[:receipt])
		#redirect_to user_path(@user)
	end
  end
  
end
