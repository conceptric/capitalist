require File.dirname(__FILE__) + '/../spec_helper'

describe Position do
  before(:each) do
    @position = Factory.build(:position)
  end

  it "is valid" do
    @position.should be_valid
  end

  describe "Asset attribute" do
    it "is associated to an Asset" do
      @position.asset.should be_instance_of(Asset)
    end

    it "prevents the associated Asset being nil" do
      @position.asset = nil
      @position.should_not be_valid
    end                                                            
  end

  describe "Transactions attribute" do
    it "is allowed to be empty" do
      @position.transactions.should be_empty
    end                        
    
    it "is associated with Transactions" do
      position = Factory(:open_position)                        
      position.transactions.size.should eql(1)
      position.purchases.size.should eql(1)
      position.sales.size.should eql(0)
      position.transactions.first.should be_instance_of(Purchase)
    end

    it "cascades deletion to associated Transactions" do
      position = Factory(:closed_position) 
      Transaction.all.size.should eql(2)
      position.destroy                 
      Position.exists?(position.id).should be_false
      Transaction.all.size.should eql(0)
    end
  end
end  

describe Position, ".current_units" do
  it "is zero when there are no transactions" do
    Factory(:position).current_units.should eql(0)    
  end

  it "is the units of a single purchase" do
    position = Factory(:open_position)
    position.transactions.size.should eql(1)
    position.current_units.should eql(5)
  end

  it "is the sum of the units of two purchases" do
    position = Factory(:open_position)
    Factory(:purchase, :position => position)
    position.transactions.size.should eql(2)
    position.current_units.should eql(10)
  end
  
  it "is the difference between the units purchased and sold" do    
    position = Factory(:closed_position)
    position.transactions.size.should eql(2)
    position.current_units.should eql(0)
  end
end

describe Position, ".units on a specified date" do
  it "is zero when there are no transactions" do
    date = Date.new(2011,1,1)
    Factory(:position).units(date).should eql(0)    
  end                                         
  
  it "is the units of a single purchase before the date" do
    date = Date.new(2010,1,2)
    Factory(:open_position).units(date).should eql(5)    
  end                                               

  it "is the units of a single purchase on the date" do
    date = Date.new(2010,1,1)
    Factory(:open_position).units(date).should eql(5)    
  end                                               
  
  it "is zero when purchase occurred after the date" do
    date = Date.new(2009,12,31)
    Factory(:open_position).units(date).should eql(0)        
  end                   
  
  it "is the difference between units bought and sold before the date" do
    date = Date.new(2011,1,2)
    Factory(:closed_position).units(date).should eql(0)            
  end                     
  
  it "is the difference between units bought and sold on the date" do
    date = Date.new(2011,1,1)
    Factory(:closed_position).units(date).should eql(0)            
  end                     

  it "is units purchased when the sale occurred after the date" do
    date = Date.new(2010,12,31)
    Factory(:closed_position).units(date).should eql(5)                
  end
end                              

describe Position, ".status" do
  before(:each) do
    @position = Factory(:position)
    @asset = @position.asset    
  end
  
  it "is open when there are no transactions" do
    @position.status.should eql('Open')    
  end

  it "is open after a purchase" do
    Factory(:purchase, :position => @position)
    @position.status.should eql('Open')    
  end

  it "is open when units still remain" do
    Factory(:purchase, :position => @position)
    Factory(:sale, :position => @position, :units => 2)
    @position.current_units.should eql(3)
    @position.status.should eql('Open')    
  end
  
  it "is closed when all the units are sold" do
    Factory(:purchase, :position => @position)
    Factory(:sale, :position => @position)
    @position.status.should eql('Closed')    
  end
end

describe ".average_unit_price" do
  before(:each) do
    @position = Factory(:position)    
    Factory(:purchase, 
            :position => @position, 
            :value => 10, 
            :units => 10)
  end
  
  it "is the unit price of a single transaction" do
    price = BigDecimal("1")   
    @position.average_unit_price.should eql(price)
  end                                           

  it "is zero when there are no transactions" do
    @position.transactions = []
    @position.average_unit_price.should eql(0)
  end

  it "is zero when the position is closed" do
    Factory(:sale, 
            :position => @position,
            :value => 20,
            :units => 10)
    @position.average_unit_price.should eql(0)
  end
  
  it "is the unit price of either of two identical transactions" do
    Factory(:purchase, 
            :position => @position, 
            :value => 10, 
            :units => 10)
    price = BigDecimal("1")   
    @position.average_unit_price.should eql(price)    
  end

  it "is in the middle when the second transaction price is twice the first" do
    Factory(:purchase, 
            :position => @position, 
            :value => 20, 
            :units => 10)
    price = BigDecimal("1.5")   
    @position.average_unit_price.should eql(price)    
  end

  it "is a 25% more when the second transaction units are 60% the first" do
    Factory(:purchase, 
            :position => @position, 
            :value => 10, 
            :units => 6)
    price = BigDecimal("1.25")   
    @position.average_unit_price.should eql(price)    
  end

  describe " of an open position including a Sale" do
    it "is the average unit price of prior purchases" do
      Factory(:purchase, 
              :position => @position, 
              :value => 10, 
              :units => 10)
      Factory(:sale, 
              :position => @position, 
              :value => 20, 
              :units => 10)
      price = BigDecimal("1")   
      @position.average_unit_price.should eql(price)    
    end                                                                           

    it "is the average price less the purchase value of the units sold" do
      Factory(:sale, 
              :date => Date.new(2010,2,1),
              :position => @position, 
              :value => 10, 
              :units => 5)
      Factory(:purchase, 
              :date => Date.new(2010,3,1),
              :position => @position, 
              :value => 10, 
              :units => 5)
      price = BigDecimal("1.5")   
      @position.average_unit_price.should eql(price)        
    end

    it "is works with a complex multi purchase and sale case" do
      Factory(:sale, 
              :date => Date.new(2010,2,1),
              :position => @position, 
              :value => 10, 
              :units => 5)
      Factory(:purchase, 
              :date => Date.new(2010,3,1),
              :position => @position, 
              :value => 10, 
              :units => 5)
      Factory(:sale, 
              :date => Date.new(2010,4,1),
              :position => @position, 
              :value => 20, 
              :units => 5)
      Factory(:purchase, 
              :date => Date.new(2010,5,1),
              :position => @position, 
              :value => 30, 
              :units => 15)
      price = BigDecimal("1.75")   
      @position.average_unit_price.should eql(price)        
    end
  end
end