class AddUnitsToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :units, :decimal, :precision => 12, :scale => 5 
  end

  def self.down
    remove_column :transactions, :units
  end
end
