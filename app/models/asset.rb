class Asset < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :transactions
  
  validates :name, :presence => true, 
            :uniqueness => true,
            :length => {:maximum => 20}

  def amount_paid
    transactions.sum('value')
  end                              
  
  def units_held
    transactions.sum('units')
  end
  
  def average_purchase_price
    if units_held > 0
      amount_paid / units_held
    else
      0
    end
  end
end
