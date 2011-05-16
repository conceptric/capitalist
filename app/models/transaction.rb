class Transaction < ActiveRecord::Base
  belongs_to :position
  belongs_to :asset
  attr_accessible :date, :position_id, :asset_id, :units, :value, :expenses
  
  validates_presence_of :date, :position_id, :units
  validates_numericality_of :units, 
                            :greater_than_or_equal_to => 0.00001,
                            :message => 'There are too few units'
end
