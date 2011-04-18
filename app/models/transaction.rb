class Transaction < ActiveRecord::Base
  attr_accessible :date, :asset_id, :total_value, :cost
  
  validates :date, :presence => true
  validates :asset_id, :presence => true
end
