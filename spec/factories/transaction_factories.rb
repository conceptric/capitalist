Factory.define :transaction, :class => Transaction do |t|
  t.date Date.new(2010,1,1)
  t.association :asset, :factory => :asset     
  t.total_value 100.10
  t.cost 10.01
end