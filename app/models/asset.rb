class Asset < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :transactions
  
  validates :name, :presence => true, 
            :uniqueness => true,
            :length => {:maximum => 20}
end
