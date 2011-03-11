class Admin::ReceiptsController < ReceiptsController

  layout "admin"

  # only authorized users can access it
  before_filter :check_admin_ability

  protected

  def get_paginated_receipts
    @receipts =  Receipt.paginate :order => 'id DESC', :per_page => 10, :page => params[:page]
  end
  
  def receipt_after_update_path
    admin_receipt_path(@receipt, :notice => 'Receipt was successfully updated.')
  end
  
  def receipt_after_delete_path
    admin_receipts_url
  end
end
