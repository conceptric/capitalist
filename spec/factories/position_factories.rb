Factory.define :position, :class => Position do |p|
  p.association :asset, :factory => :asset
end

Factory.define :open_position, :parent => :position do |p|
  p.after_create do |position|    
    Factory(:purchase, :position => position)
  end
end

Factory.define :closed_position, :parent => :open_position do |p|
  p.after_create do |position|    
    Factory(:sale, :position => position)
  end
end