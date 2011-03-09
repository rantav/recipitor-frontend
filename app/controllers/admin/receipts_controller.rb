class Admin::ReceiptsController < ReceiptsController

  layout "admin"

  # only authorized users can access it
  before_filter :check_admin_ability


  # DELETE /admin/receipts/1
  # DELETE /admin/receipts/1.xml
  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to(admin_receipts_url) }
      format.xml  { head :ok }
      format.js
    end
  end

  protected

  def get_paginated_receipts
    @receipts =  Receipt.paginate :order => 'id DESC', :per_page => 10, :page => params[:page]
  end
  
  def receipt_after_update_path
    admin_receipt_path(@receipt, :notice => 'Receipt was successfully updated.')
  end
end
