class Sale < Transaction
  validate :position_empty?, :sale_covered?, 
    :unless => Proc.new { |a| a.position.nil? || a.units.nil? || a.date.nil? }
  
  def position_empty?                                             
    if position.purchases.empty?
      errors.add(:nothing_to_sell, "you don't have a Position on this Asset") 
    end
  end                                          
  
  def sale_covered?
    if position.purchases.where("date < ?", date).sum('units') < units 
      errors.add(:selling_too_many_units, 
        "you don't hold enough units in this Asset to cover the sale")
    end
  end
end