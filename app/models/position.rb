class Position < ActiveRecord::Base
  belongs_to :asset
  attr_accessible :asset_id
  
  validates_presence_of :asset_id
end
