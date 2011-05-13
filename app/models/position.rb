class Position < ActiveRecord::Base
  belongs_to :asset      
  has_many :transactions, :order => "date ASC"
  
  attr_accessible :asset_id
  
  validates_presence_of :asset_id
end
