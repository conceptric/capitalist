class Asset < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :positions
  has_many :transactions, :order => "date ASC"
  has_many :purchases, :order => "date ASC"
  has_many :sales, :order => "date ASC"
  
  validates :name, :presence => true, 
            :uniqueness => true,
            :length => {:maximum => 20}

  def amount_paid
    purchases.sum('value')
  end                              
  
  def units_held
    purchases.sum('units') - sales.sum('units')
  end
  
  def unit_price
    if units_held > 0
      amount_paid / purchases.sum('units')
    else
      0
    end
  end
end
