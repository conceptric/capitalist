Factory.define :named_asset, :class => Asset do |a|
  a.name 'NAM'
end

Factory.define :asset, :class => Asset do |a|
  a.name {Factory.next :asset_name}
end

Factory.define :asset_with_position, :parent => :asset do |a|
  a.after_create do |asset|    
    Factory(:position, :asset => asset)
  end
end

Factory.sequence :asset_name do |n|
  "asset#{n}"
end