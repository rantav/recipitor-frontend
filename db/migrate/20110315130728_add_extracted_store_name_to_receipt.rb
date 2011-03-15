class AddExtractedStoreNameToReceipt < ActiveRecord::Migration
  def self.up
    add_column :receipts, :extracted_store_name, :string
  end

  def self.down
    remove_column :receipts, :extracted_store_name
  end
end
