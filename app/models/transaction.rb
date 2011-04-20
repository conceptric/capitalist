class Transaction < ActiveRecord::Base
  belongs_to :asset
  attr_accessible :date, :asset_id, :units, :total_value, :cost
  
  validates_presence_of :date, :asset_id, :units
  validates_numericality_of :units, :greater_than_or_equal_to => 0.00001
end
