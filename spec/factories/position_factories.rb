Factory.define :position, :class => Position do |p|
  p.association :asset, :factory => :asset
end

Factory.define :open_position, :parent => :position do |p|
  p.purchases {|p| [p.association(:purchase, :asset => p.asset)]}
end

Factory.define :closed_position, :parent => :open_position do |p|
  p.sales {|s| [s.association(:sale, :asset => s.asset)]}
end