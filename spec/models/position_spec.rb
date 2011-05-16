require File.dirname(__FILE__) + '/../spec_helper'

describe Position do
  before(:each) do
    @position = Factory.build(:position)
  end

  it "should be valid" do
    @position.should be_valid
  end

  describe "Asset attribute" do
    it "should be associated to an Asset" do
      @position.asset.should be_instance_of(Asset)
    end

    it "should not allow the associated Asset to be nil" do
      @position.asset = nil
      @position.should_not be_valid
    end                                                            
  end
end  

describe Position, ".current_units" do
  it "should be zero when there are no transactions" do
    Factory(:position).current_units.should eql(0)    
  end

  it "should be the units for a purchase" do
    position = Factory(:open_position)
    position.transactions.size.should eql(1)
    position.current_units.should eql(5)
  end

  it "should be the sum of the units for two purchases" do
    position = Factory(:open_position)
    Factory(:purchase, :position => position)
    position.transactions.size.should eql(2)
    position.current_units.should eql(10)
  end
  
  it "should be the difference between the units purchased and sold" do    
    position = Factory(:closed_position)
    position.transactions.size.should eql(2)
    position.current_units.should eql(0)
  end
end

describe Position, ".status" do
  before(:each) do
    @position = Factory(:position)
    @asset = @position.asset    
  end
  
  it "should be open when there are no transactions" do
    @position.status.should eql('Open')    
  end

  it "should be open after a purchase" do
    Factory(:purchase, :position => @position, :asset => @asset)
    @position.status.should eql('Open')    
  end

  it "should be open when some of the asset remains" do
    Factory(:purchase, :position => @position, :asset => @asset)
    Factory(:sale, :position => @position, :asset => @asset, :units => 2)
    @position.current_units.should eql(3)
    @position.status.should eql('Open')    
  end
  
  it "should be closed when all the asset has been sold" do
    Factory(:purchase, :position => @position, :asset => @asset)
    Factory(:sale, :position => @position, :asset => @asset)
    @position.status.should eql('Closed')    
  end
end


