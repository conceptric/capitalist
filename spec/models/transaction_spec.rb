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

  describe "Position attribute" do
    it "should be associated to a Position" do
      @transaction.position.should be_instance_of(Position)
    end

    it "should not allow the associated Position to be nil" do
      @transaction.position = nil
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
      @transaction.value.should eql(100.10)
    end  

    it "should return the correct cost decimal" do
      @transaction.expenses.should eql(10.01)
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
    @position = Factory(:open_position)
    @transaction = Factory.build(:sale, :position => @position)
  end
  
  it_should_behave_like "A Transaction"

  describe "Decimal attributes" do
    it "should return the correct value decimal" do
      @transaction.value.should eql(200.10)
    end  

    it "should return the correct cost decimal" do
      @transaction.expenses.should eql(10.01)
    end      
  end                      

  describe "Date attribute" do
    it "should have a valid date" do
      @transaction.date.should be_instance_of(Date)
      @transaction.date.should eql(Date.new(2011,1,1))
    end    
  end
end

describe Sale, " validates there is something to sell" do
  before :each do
    @position = Factory(:open_position)
    @transaction = Factory.build(:sale, :position => @position)
  end
  
  it "prevents a sale being the first transaction in a position" do
    Transaction.delete_all
    @transaction.should_not be_valid
  end
  
  it "is invalid if the sale is before the purchase" do
    @transaction.date = Date.new(2009,1,1)
    @transaction.should_not be_valid
  end
end

describe Sale, " validates there is enough to sell" do    
  before(:each) do
    @position = Factory(:open_position)           
    @transaction = Factory(:sale, :position => @position, :units => 3)
  end

  it "is invalid if selling more units than have been purchased" do
    @transaction.units = 10
    @transaction.should_not be_valid
  end

  it "is invalid if too few units were purchased before the sale" do
    Factory(:purchase, :position => @position, :date => Date.new(2011,2,1))
    @transaction.units = 10
    @transaction.should_not be_valid
  end
    
  it "prevents position invalidation when a sale is inserted" do
    transaction = Factory.build(:sale, :position => @position)
    transaction.date = Date.new(2010,10,1)
    transaction.should_not be_valid      
  end

  it "is valid when updating an existing sale with fewer units" do
    @transaction.units = 1     
    @transaction.should be_valid            
  end

  it "is invalid when updating a sale with too many units" do
    @transaction.units = 6     
    @transaction.should_not be_valid            
  end

  it "when updating an existing sale with more available units" do
    @transaction.units = 5
    @transaction.should be_valid            
  end
end