class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.date :date
      t.integer :asset_id
      t.decimal :total_value
      t.decimal :cost
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
