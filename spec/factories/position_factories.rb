Factory.define :position, :class => Position do |p|
  p.association :asset, :factory => :asset
end