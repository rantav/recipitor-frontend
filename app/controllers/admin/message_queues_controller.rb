class Admin::MessageQueuesController < ApplicationController

  layout "admin"

  # only authorized users can access it
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :check_admin_ability

  def index
    @queues = MessageQueue.list
  end

  def show
    @mq = MessageQueue.find(params[:id])
  end

  def clear
    @mq = MessageQueue.find(params[:id])
    logger.info "Clearing queue #{@mq}"
    @mq.clear
    redirect_to admin_message_queue_url
  end

  def destroy
    clear
  end

  def edit
    @mq = MessageQueue.find(params[:id])
    render :action => "send"
  end

  def update
    @mq = MessageQueue.new(params[:id])
    respond_to do |format|
      message = params[:message]
      if message.nil? or message.empty?
        format.html { render :action => "send" }
        format.xml { render :xml => @mq.errors, :status => :unprocessable_entity }
        format.json { render :json => @mq.errors, :status => :unprocessable_entity }
      else
        @mq.send message
        format.html { redirect_to admin_message_queue_after_update_path, :notice => "Message was sent" }
        format.xml { head :ok }
        format.json { render :json => {:status => :ok} }
      end
    end
  end

end
