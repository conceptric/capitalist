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
      if sales.empty?
        purchases.sum('value') / purchases.sum('units')
      else    
        first_purchases = purchases.where("date <= ?", sales.first.date)
        last_purchases = purchases.where("date > ?", sales.first.date) 
        
        if last_purchases.empty?
          purchases.sum('value') / purchases.sum('units')
        else            
          working_price = 0
          
          first_purchases.each do |purchase|
            working_price += 
            (purchase.unit_price * (purchase.units /
             units(purchase.date))).round(5)
          end
                 
          first_value = (working_price * units(sales.first.date))
          last_value = last_purchases.sum('value')
          (first_value + last_value) / current_units
        end
      end
    end
  end
  
  def status
    if !transactions.empty? && current_units == 0
      'Closed'
    else
      'Open'
    end
  end
end
