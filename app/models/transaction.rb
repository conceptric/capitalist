class Transaction < ActiveRecord::Base
  attr_accessible :date, :position_id, :units, :value, :expenses

  belongs_to :position
  
  validates_presence_of :date, :position_id, :units, :value, :expenses
  validates_numericality_of :units, 
                            :greater_than_or_equal_to => 0.00001,
                            :message => 'There are too few units'
  validates_numericality_of :value, 
                            :greater_than_or_equal_to => 0,
                            :message => 'Must be positive'
  validates_numericality_of :expenses, 
                            :greater_than_or_equal_to => 0,
                            :message => 'Must be positive'

  def unit_price 
    if value.nil? || units.nil? || units == 0
      0
    else
      value / units
    end
  end                           
end
