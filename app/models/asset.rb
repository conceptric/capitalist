class Asset < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :transactions, :order => "date ASC"
  has_many :purchases, :order => "date ASC"
  
  validates :name, :presence => true, 
            :uniqueness => true,
            :length => {:maximum => 20}

  def amount_paid
    purchases.sum('value')
  end                              
  
  def units_held
    purchases.sum('units')
  end
  
  def average_purchase_price
    if units_held > 0
      amount_paid / units_held
    else
      0
    end
  end
end
