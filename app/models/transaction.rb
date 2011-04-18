class Transaction < ActiveRecord::Base
  belongs_to :asset
  attr_accessible :date, :asset_id, :total_value, :cost
  
  validates :date, :presence => true
  validates :asset_id, :presence => true
end
