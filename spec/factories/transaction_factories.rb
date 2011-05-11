Factory.define :transaction, :class => Purchase do |t|
  t.date Date.new(2010,1,1)
  t.association :asset, :factory => :asset     
  t.units 5
  t.total_value 100.10
  t.cost 10.01
end