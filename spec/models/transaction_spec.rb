require File.dirname(__FILE__) + '/../spec_helper'

shared_examples_for "A Transaction" do
  it "is valid" do
    @transaction.should be_valid    
  end

  describe "Date attribute" do
    it "has a date" do
      @transaction.date = nil
      @transaction.should_not be_valid
    end

    it "is a valid date" do
      @transaction.date.should be_instance_of(Date)
      @transaction.date.should eql(@date)
    end    
  end
  
  describe "Position attribute" do
    it "is associated to a Position" do
      @transaction.position.should be_instance_of(Position)
    end

    it "can be nil" do
      @transaction.position = nil
      @transaction.should_not be_valid
    end                                                            
  end

  describe "Units attribute" do
    it "is a decimal number of units" do 
      @transaction.units = 1111111.11111
      @transaction.units.should eql(1111111.11111)
    end

    it "cannot be blank" do
      @transaction.units = nil
      @transaction.should_not be_valid
    end                               

    it "allows a small decimal" do
      @transaction.units = 0.00001
      @transaction.should be_valid
    end                               

    it "is no more than 5 decimal places" do
      @transaction.units = 0.000009
      @transaction.should_not be_valid
    end                               
    
    it "cannot be zero" do
      @transaction.units = 0
      @transaction.should_not be_valid
    end                               

    it "cannot be negative" do
      @transaction.units = -0.00001
      @transaction.should_not be_valid
    end                                   
  end
  
  describe "Value attribute" do
    it "has the correct decimal format" do
      @transaction.value.should eql(@value)
    end                                   
    
    it "cannot be negative" do
      @transaction.value = -1
      @transaction.should_not be_valid
    end

    it "can be zero" do
      @transaction.value = 0
      @transaction.should be_valid
    end

    it "cannot be nil" do
      @transaction.value = nil
      @transaction.should_not be_valid
    end
  end
  
  describe "Expenses attribute" do    
    it "has the correct decimal format" do
      @transaction.expenses.should eql(@expense)
    end      

    it "cannot be negative" do
      @transaction.expenses = -1
      @transaction.should_not be_valid
    end

    it "can be zero" do
      @transaction.expenses = 0
      @transaction.should be_valid
    end

    it "cannot be nil" do
      @transaction.expenses = nil
      @transaction.should_not be_valid
    end
  end                      

  describe ".unit_price" do
    it "has the correct decimal format" do        
      unit_price = @transaction.value / @transaction.units
      price = BigDecimal.new("#{unit_price}").round(5)
      @transaction.unit_price.should eql(price)
    end

    it "is zero when value is nil" do
      @transaction.value = nil
      @transaction.unit_price.should eql(0)
    end

    it "is zero when value is zero" do
      @transaction.value = 0
      @transaction.unit_price.should eql(0)
    end

    it "is zero when units is nil" do
      @transaction.units = nil
      @transaction.unit_price.should eql(0)
    end

    it "is zero when units is zero" do
      @transaction.units = 0
      @transaction.unit_price.should eql(0)
    end
  end
end

describe Purchase, ".new" do
  before :each do
    @transaction = Factory.build(:purchase)
    @value = 100.10
    @expense = 10.01
    @date = Date.new(2010,1,1)
  end
  
  it_should_behave_like "A Transaction"

end

describe Sale, ".new" do
  before :each do
    @position = Factory(:open_position)
    @transaction = Factory.build(:sale, :position => @position)
    @value = 200.10
    @expense = 10.01
    @date = Date.new(2011,1,1)
  end
  
  it_should_behave_like "A Transaction"

end