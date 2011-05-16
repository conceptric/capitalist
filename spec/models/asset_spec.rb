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

describe Asset, ".current_units" do
  before(:each) do
    Position.any_instance.stubs(:current_units).returns(5)    
    @asset = Factory(:asset)
  end

  it "should be zero when there are no positions" do
    @asset.current_units.should eql(0)    
  end

  it "should be total units held a single position" do    
    Factory(:position, :asset => @asset)
    @asset.current_units.should eql(5)
  end

  it "should be the sum of total units in two positions" do
    Factory(:position, :asset => @asset)
    Factory(:position, :asset => @asset)
    @asset.current_units.should eql(10)
  end
end
