class Position < ActiveRecord::Base
  attr_accessible :asset_id
  
  belongs_to :asset      
  has_many :transactions, :order => "date ASC", :dependent => :destroy
  has_many :purchases, :order => "date ASC"
  has_many :sales, :order => "date ASC"
  
  validates_presence_of :asset_id

  def status
    if !transactions.empty? && current_units == 0
      'Closed'
    else
      'Open'
    end
  end    

  def units(a_date=Time.now)
    bought = purchases.where("date <= ?", a_date).sum('units')
    sold = sales.where("date <= ?", a_date).sum('units')    
    bought - sold
  end

  def current_units
    units
  end              
  
  def average_unit_price                           
    if status == "Closed" || transactions.empty?
      0
    else
      investment_value_of_purchases = purchases.sum('value') 
      ( investment_value_of_purchases - 
        investment_value_of_sales ) / current_units
    end                          
  end                            
    
  private
  
  def investment_value_of_sales
    sold = 0
    if !sales.empty?
      sales.each do |sale|
        invested_value = purchases.where("date <= ?", sale.date).sum('value')
        invested_units = units(sale.date) + sale.units
        effective_purchase_price = invested_value / invested_units
        sold += effective_purchase_price * sale.units
      end
    end
    sold
  end  
end
