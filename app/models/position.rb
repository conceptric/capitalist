class Position < ActiveRecord::Base
  attr_accessible :asset_id
  
  belongs_to :asset      
  has_many :transactions, :order => "date ASC", :dependent => :destroy
  has_many :purchases, :order => "date ASC"
  has_many :sales, :order => "date ASC"
  
  validates_presence_of :asset_id

  def units(a_date)
    bought = purchases.where("date <= ?", a_date).sum('units')
    sold = sales.where("date <= ?", a_date).sum('units')    
    bought - sold
  end

  def current_units
    purchases.sum('units') - sales.sum('units')
  end              

  def average_unit_price                           
    if status == "Closed" || transactions.empty?
      0
    else
      money_paid = purchases.sum('value') 
      (money_paid - value_of_sold) / current_units
    end                          
  end                            
  
  def value_of_sold
    sold = 0
    if !sales.empty?
      sales.each do |sale|
        invested_value = purchases.where("date <= ?", sale.date).sum('value')
        invested_units = units(sale.date) + sale.units
        average_price = invested_value / invested_units
        sold += average_price * sale.units
      end
    end
    sold
  end
  
  def status
    if !transactions.empty? && current_units == 0
      'Closed'
    else
      'Open'
    end
  end
end
