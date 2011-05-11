class Sale < Transaction
  validate :asset_held?
  
  def asset_held?
    errors.add(:nothing_to_sell, "you don't hold this Asset") if
      asset == nil || Purchase.where(:asset_id => asset.id).empty?
  end
end