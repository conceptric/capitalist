class Asset < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :positions
  has_many :transactions, :order => "date ASC"
  has_many :purchases, :order => "date ASC"
  has_many :sales, :order => "date ASC"
  
  validates :name, :presence => true, 
            :uniqueness => true,
            :length => {:maximum => 20}

  def units_held 
    total = 0
    positions.each do |position|
      total += position.current_units
    end
    total
  end  
end
