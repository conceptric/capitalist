class Sale < Transaction
  validate :asset_held?, :units_to_cover_sale?, 
    :unless => Proc.new { |a| a.asset.nil? || a.units.nil? || a.date.nil? }
  
  def asset_held?
    errors.add(:nothing_to_sell, "you don't hold this Asset") if
      Purchase.where(:asset_id => asset.id).empty?
  end                                          
  
  def units_to_cover_sale?
    errors.add(:selling_too_many_units, 
               "you don't hold enough units in this Asset to cover the sale") if
      Purchase.where(:asset_id => asset.id).where("date < ?", date).sum('units') < units
  end
end