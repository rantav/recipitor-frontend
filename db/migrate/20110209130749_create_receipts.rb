class CreateReceipts < ActiveRecord::Migration
  def self.up
    create_table :receipts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :receipts
  end
end
