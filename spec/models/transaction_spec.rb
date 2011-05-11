require File.dirname(__FILE__) + '/../spec_helper'

describe Transaction, ".new" do
  before :each do
    @transaction = Factory.build(:purchase)
  end

  it "should be valid" do
    @transaction.should be_valid    
  end
  
  describe "Date attribute" do
    it "should have a date" do
      @transaction.date = nil
      @transaction.should_not be_valid
    end

    it "should have a valid date" do
      @transaction.date.should be_instance_of(Date)
      @transaction.date.should eql(Date.new(2010,1,1))
    end    
  end

  describe "Asset attribute" do
    it "should be associated to an Asset" do
      @transaction.asset.should be_instance_of(Asset)
    end

    it "should not allow the associated Asset to be nil" do
      @transaction.asset = nil
      @transaction.should_not be_valid
    end                                                            
  end
  
  describe "Units attribute" do
    it "should comprise a decimal number of units" do 
      @transaction.units = 1111111.11111
      @transaction.units.should eql(1111111.11111)
    end

    it "should not allow the number of units to be blank" do
      @transaction.units = nil
      @transaction.should_not be_valid
    end                               

    it "should allow the number of units to be a small decimal" do
      @transaction.units = 0.00001
      @transaction.should be_valid
    end                               

    it "should not allow units to use more than 5 decimal places" do
      @transaction.units = 0.000009
      @transaction.should_not be_valid
    end                               
    
    it "should not allow the number of units to be zero" do
      @transaction.units = 0
      @transaction.should_not be_valid
    end                               

    it "should not allow the number of units to be negative" do
      @transaction.units = -0.00001
      @transaction.should_not be_valid
    end                                   
  end

  it "should return the correct value and cost decimal values" do
    @transaction.total_value.should eql(100.10)
    @transaction.cost.should eql(10.01)
  end
end
