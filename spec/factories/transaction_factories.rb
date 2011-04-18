Factory.define :transaction, :class => Transaction do |t|
  t.date Date.new(2010,1,1)
  t.association :asset, :factory => :asset
end