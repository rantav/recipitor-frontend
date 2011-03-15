class Admin::MessageQueuesController < ApplicationController

  layout "admin"

  # only authorized users can access it
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :check_admin_ability

  def index
    @queues = MessageQueue.list
  end
end
