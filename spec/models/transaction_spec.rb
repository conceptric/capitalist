require File.dirname(__FILE__) + '/../spec_helper'

describe Transaction, ".new" do
  before :each do
    @transaction = Factory.build(:transaction)
  end

  it "should be valid" do
    Factory(:transaction).should be_valid
  end
  
  it "should have a date" do
    transaction = Factory.build(:transaction)
    transaction.date = nil
    transaction.should_not be_valid
  end
  
  it "should be associated to an Asset" do
    transaction = Factory.build(:transaction)
    transaction.asset_id = nil
    transaction.should_not be_valid
  end
end
