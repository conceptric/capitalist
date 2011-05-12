require File.dirname(__FILE__) + '/../spec_helper'

describe Asset, ".new" do
  before :each do
    @asset = Factory(:asset)
  end

  after :all do
    Asset.delete_all
  end

  describe "Name attribute" do
    it "should be valid with a name" do
      @asset.should be_valid
    end

    it "should have a unique name" do
      Factory.build(:asset, @asset.attributes).should_not be_valid
    end

    it "should be invalid without a name" do
      @asset.name = nil
      @asset.should_not be_valid
    end

    it "should be invalid if the name is longer than 20 characters" do
      @asset.name = 'abcdeabcdeabcdeabcdef'
      @asset.should_not be_valid
    end    
  end
end

describe Asset, ".amount_paid" do
  it "should return the sum of the transaction values" do
    asset = Factory(:asset)
    Factory(:purchase, :asset => asset)
    Factory(:purchase, :asset => asset)
    asset.amount_paid.should eql(200.20)
  end
  
  it "should return zero when there are no transactions" do
    asset = Factory(:asset)
    asset.amount_paid.should eql(0)    
  end
end

describe Asset, ".units_held" do
  it "should be zero when there are no transactions" do
    asset = Factory(:asset)
    asset.units_held.should eql(0)    
  end

  it "should be the units for a purchase" do
    asset = Factory(:asset)
    Factory(:purchase, :asset => asset)
    asset.units_held.should eql(5)
  end

  it "should be the sum of the units for two purchases" do
    asset = Factory(:asset)
    Factory(:purchase, :asset => asset)
    Factory(:purchase, :asset => asset)
    asset.units_held.should eql(10)
  end
  
  it "should be the difference between the units purchased and sold" do
    asset = Factory(:asset)
    Factory(:purchase, :asset => asset)
    Factory(:sale, :asset => asset)
    asset.units_held.should eql(0)
  end
end

describe Asset, ".unit_price" do
  it "should be zero when there are no units" do
    asset = Factory(:asset)
    Purchase.any_instance.stubs(:valid?).returns(true)
    Factory(:purchase, :asset => asset, :units => 0)
    asset.unit_price.should eql(0)    
  end

  it "should be the average unit price for a single purchase" do
    asset = Factory(:asset)
    Factory(:purchase, :asset => asset)
    asset.unit_price.should eql(20.02)
  end

  it "should be the average unit price for two purchases" do
    asset = Factory(:asset)
    Factory(:purchase, :asset => asset)
    Factory(:purchase, :asset => asset)
    asset.unit_price.should eql(20.02)
  end

  it "should be zero for a complete purchase and sale cycle" do
    asset = Factory(:asset)
    Factory(:purchase, :asset => asset)
    Factory(:sale, :asset => asset)
    asset.unit_price.should eql(0)
  end

  it "should be the average of two purchases if partially sold" do
    asset = Factory(:asset)
    Factory(:purchase, :asset => asset)
    Factory(:sale, :asset => asset)
    Factory(:purchase, :asset => asset)
    asset.unit_price.should eql(20.02)
  end  
end