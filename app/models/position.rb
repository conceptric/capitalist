class Position < ActiveRecord::Base
  belongs_to :asset      
  has_many :transactions, :order => "date ASC"
  has_many :purchases, :order => "date ASC"
  has_many :sales, :order => "date ASC"
  
  attr_accessible :asset_id
  
  validates_presence_of :asset_id

  def current_units
    purchases.sum('units') - sales.sum('units')
  end              
  
  def status
    if !transactions.empty? && current_units == 0
      'Closed'
    else
      'Open'
    end
  end
end
