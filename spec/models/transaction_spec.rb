require File.dirname(__FILE__) + '/../spec_helper'

shared_examples_for "A Transaction" do
  it "should be valid" do
    @transaction.should be_valid    
  end
  
  describe "Date attribute" do
    it "should have a date" do
      @transaction.date = nil
      @transaction.should_not be_valid
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

end

describe Purchase, ".new" do
  before :each do
    @transaction = Factory.build(:purchase)
  end
  
  it_should_behave_like "A Transaction"

  describe "Decimal attributes" do
    it "should return the correct value decimal" do
      @transaction.total_value.should eql(100.10)
    end  

    it "should return the correct cost decimal" do
      @transaction.cost.should eql(10.01)
    end      
  end                      

  describe "Date attribute" do
    it "should have a valid date" do
      @transaction.date.should be_instance_of(Date)
      @transaction.date.should eql(Date.new(2010,1,1))
    end    
  end
end

describe Sale, ".new" do
  before :each do
    asset = Factory(:asset)
    Factory(:purchase, :asset => asset)
    @transaction = Factory.build(:sale, :asset => asset)
  end
  
  it_should_behave_like "A Transaction"

  describe "Decimal attributes" do
    it "should return the correct value decimal" do
      @transaction.total_value.should eql(200.10)
    end  

    it "should return the correct cost decimal" do
      @transaction.cost.should eql(10.01)
    end      
  end                      

  describe "Date attribute" do
    it "should have a valid date" do
      @transaction.date.should be_instance_of(Date)
      @transaction.date.should eql(Date.new(2011,1,1))
    end    
  end

  describe "Conditions of sale" do
    it "should not be valid if selling an asset you do not own" do
      Purchase.delete_all
      @transaction.should_not be_valid
    end                               
    
    it "should not be valid if selling more units than have been purchased" do
      @transaction.units = 10
      @transaction.should_not be_valid
    end
    
    it "should not be valid if the sale is before the purchase"
  end
end
