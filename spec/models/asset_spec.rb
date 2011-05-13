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

describe Asset, ".units_held" do
  it "should be zero when there are no positions" do
    asset = Factory(:asset)
    asset.units_held.should eql(0)    
  end

  it "should be total units held a single position" do
    asset = Factory(:asset)
    Factory(:open_position, :asset => asset)
    asset.units_held.should eql(5)
  end

  it "should be the sum of total units in two positions" do
    asset = Factory(:asset)
    Factory(:open_position, :asset => asset)
    Factory(:open_position, :asset => asset)
    asset.units_held.should eql(10)
  end

  it "should be the sum of total units in two open and one closed position" do
    asset = Factory(:asset)
    Factory(:open_position, :asset => asset)
    Factory(:open_position, :asset => asset)
    Factory(:closed_position, :asset => asset)
    asset.units_held.should eql(10)
  end
end
