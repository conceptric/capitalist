class RemoveAssetIdFromTransactions < ActiveRecord::Migration
  def self.up
    remove_column :transactions, :asset_id
  end

  def self.down
    add_column :transactions, :asset_id, :integer
  end
end
