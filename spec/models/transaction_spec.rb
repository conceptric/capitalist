require File.dirname(__FILE__) + '/../spec_helper'

describe Transaction, ".new" do
  before :each do
    @transaction = Factory.build(:transaction)
  end

  it "should be valid" do
    @transaction.should be_valid    
  end
  
  it "should have a date" do
    @transaction.date = nil
    @transaction.should_not be_valid
  end

  it "should have a valid date" do
    @transaction.date.should be_instance_of(Date)
    @transaction.date.should eql(Date.new(2010,1,1))
  end

  it "should be associated to an Asset" do
    @transaction.asset.should be_instance_of(Asset)
  end
  
  it "should not allow the associated Asset to be nil" do
    @transaction.asset = nil
    @transaction.should_not be_valid
  end
end
