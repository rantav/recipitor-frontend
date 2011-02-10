class AddDescriptionToReceipt < ActiveRecord::Migration
  def self.up
    add_column :receipts, :description, :string
  end

  def self.down
    remove_column :receipts, :description
  end
end
