require File.dirname(__FILE__) + '/../spec_helper'

describe Sale, " validation" do
  before :each do
    @position = Factory(:open_position)
    @transaction = Factory.build(:sale, :position => @position)
  end
  
  it "prevents a sale being the first transaction in a position" do
    Transaction.delete_all
    @transaction.should_not be_valid
  end
  
  it "prevents selling before buying" do
    @transaction.date = Date.new(2009,1,1)
    @transaction.should_not be_valid
  end
end

describe Sale, " validates the amount being sold" do    
  before(:each) do
    @position = Factory(:open_position)           
    @transaction = Factory(:sale, :position => @position, :units => 3)
  end

  it "if selling more units than have been purchased" do
    @transaction.units = 10
    @transaction.should_not be_valid
  end

  it "if too few units were purchased before the sale" do
    Factory(:purchase, :position => @position, :date => Date.new(2011,2,1))
    @transaction.units = 10
    @transaction.should_not be_valid
  end
    
  it "once a new sale is inserted before an old one" do
    transaction = Factory.build(:sale, :position => @position)
    transaction.date = Date.new(2010,10,1)
    transaction.should_not be_valid      
  end

  it "when reducing the size of an existing sale" do
    @transaction.units = 1     
    @transaction.should be_valid            
  end

  it "when increasing the size of an existing sale too much" do
    @transaction.units = 6     
    @transaction.should_not be_valid            
  end

  it "when increasing the size of an existing sale to sell everything" do
    @transaction.units = 5
    @transaction.should be_valid            
  end
end