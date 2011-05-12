class RenameTransactionCost < ActiveRecord::Migration
  def self.up
    change_table :transactions do |t|
      t.rename :total_value, :value
      t.rename :cost, :expenses
    end
  end

  def self.down
    change_table :transactions do |t|
      t.rename :value, :total_value
      t.rename :expenses, :cost
    end
  end
end
