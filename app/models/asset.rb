class Asset < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :positions, :dependent => :destroy
  
  validates :name, :presence => true, 
            :uniqueness => true,
            :length => {:maximum => 20}

  def current_units 
    total = 0
    positions.each do |position|
      total += position.current_units
    end
    total
  end  
end
