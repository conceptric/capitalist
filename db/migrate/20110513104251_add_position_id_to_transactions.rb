class AddPositionIdToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :position_id, :integer
  end

  def self.down
    add_column :transactions, :position_id
  end
end
