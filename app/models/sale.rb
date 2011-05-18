class Sale < Transaction
  validate :position_empty?, :sale_covered?, 
    :unless => Proc.new { |a| a.position.nil? || a.units.nil? || a.date.nil? }
  
  def position_empty?                                             
    if position.purchases.empty?
      errors.add(:nothing_to_sell, "you don't have a Position on this Asset") 
    end
  end                                          
  
  def sale_covered?
    if available_units < units || available_units_before(date) < units
      errors.add(:selling_too_many_units, 
        "you don't hold enough units in this Asset to cover the sale")
    end
  end                         
  
  private      
  
  def available_units_before(a_date)
    if id != nil && position.sales.exists?(id)
      position.units(a_date) + position.sales.find(id).units
    else
      position.units(a_date)
    end
  end
  
  def available_units             
    if id != nil && position.sales.exists?(id)
      position.current_units + position.sales.find(id).units
    else
      position.current_units
    end
  end
end