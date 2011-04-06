class AddTagsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :tags, :string
  end

  def self.down
    remove_column :users, :tags
  end
end
