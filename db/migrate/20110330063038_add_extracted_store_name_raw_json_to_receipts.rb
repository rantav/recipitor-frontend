class AddExtractedStoreNameRawJsonToReceipts < ActiveRecord::Migration
  def self.up
    add_column :receipts, :extracted_store_name_raw_json, :string
  end

  def self.down
    remove_column :receipts, :extracted_store_name_raw_json
  end
end
